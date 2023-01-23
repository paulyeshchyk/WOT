//
//  WOTTankDetailViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailViewController.h"
#import "Tanks.h"
#import "Tankengines.h"
#import "Vehicles.h"
#import "ModulesTree.h"

#import "WOTRequestExecutor.h"
#import "WOTTankDetailDatasource.h"
#import "WOTTankModuleTreeViewController.h"

#import "WOTTankIdsDatasource.h"

#import "WOTTankDetailSection+Factory.h"

#import "WOTTankGridViewController.h"

#import "WOTTankMetricsList.h"
#import "WOTMetric.h"
#import "WOTTanksIDList.h"
#import "WOTTankMetricOptions.h"

#import "WOTMetric+Samples.h"

#import "WOTRadarViewController.h"

@interface WOTTankDetailViewController () <NSFetchedResultsControllerDelegate, WOTRadarViewControllerDelegate, WOTGridViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, weak) IBOutlet UIToolbar *topBar;

@property (nonatomic, weak) IBOutlet UIButton *viewModeRadarButton;
@property (nonatomic, weak) IBOutlet UIButton *viewModeGridButton;

@property (nonatomic, weak) IBOutlet UIButton *propertyMobilityButton;
@property (nonatomic, weak) IBOutlet UIButton *propertyArmorButton;
@property (nonatomic, weak) IBOutlet UIButton *propertyObserveButton;
@property (nonatomic, weak) IBOutlet UIButton *propertyFireButton;

@property (nonatomic, weak) IBOutlet UIButton *configurationCustomButton;
@property (nonatomic, weak) IBOutlet UIButton *configurationTopButton;
@property (nonatomic, weak) IBOutlet UIButton *configurationDefaultButton;

@property (nonatomic, strong) NSArray *viewContainerConstraints;
@property (nonatomic, weak) IBOutlet UIView *viewContainer;
@property (nonatomic, strong)WOTTankGridViewController *gridViewController;
@property (nonatomic, strong)WOTRadarViewController *radarViewController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@property (nonatomic, strong) NSError *fetchError;

@property (nonatomic, assign)WOTTankDetailViewMode viewMode;
@property (nonatomic, assign)WOTTankMetricOptions metricOptions;
@property (nonatomic, strong)Vehicles *vehicle;
@property (nonatomic, strong)NSMutableSet *runningRequestIDs;

@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSString *requestId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_ITEM, self.tankId];
    [[WOTRequestExecutor sharedInstance] cancelRequestsByGroupId:requestId];
    
    [self.runningRequestIDs enumerateObjectsUsingBlock:^(id requestID, BOOL *stop) {
        
        [[WOTRequestExecutor sharedInstance] cancelRequestsByGroupId:requestID];
    }];
    
    [self.runningRequestIDs removeAllObjects];
    
    self.fetchedResultController.delegate = nil;
    
    self.radarViewController.delegate = nil;
    self.radarViewController = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return self;
}

- (NSString *)prevModuleNamesForModule:(ModulesTree *)moduleTree {
    
    NSString *result = nil;
    NSString *name = moduleTree.name;
    if (moduleTree.prevModules) {
        
        NSString *prevModule = [self prevModuleNamesForModule:moduleTree.prevModules];
        result = [NSString stringWithFormat:@"%@ - %@",prevModule,name];
    } else {
        
        result = [NSString stringWithFormat:@"%@",name];
    }
    return result;
    
}

- (void)printModule:(ModulesTree *)module level:(NSInteger)level{

    NSSet *next = module.nextModules;
    if ([next count] == 0) {
        
        NSString *res = [self prevModuleNamesForModule:module];
        debugLog(@"%@", res);
    }
    [next enumerateObjectsUsingBlock:^(ModulesTree *nextModule, BOOL *stop) {
        
        [self printModule:nextModule level:(level+1)];
    }];
    
}

- (void)setMetricOptions:(WOTTankMetricOptions)metricOptions {

    if (metricOptions == WOTTankMetricOptionNone) {
        
        if (_metricOptions == WOTTankMetricOptionNone) {
            
            _metricOptions = WOTTankMetricOptionArmor;
        } else {
            
            //do nothing; leave as is
        }
    } else {
        
        _metricOptions = metricOptions;
    }
    
    self.propertyArmorButton.selected = [WOTMetric options:self.metricOptions includesOption:WOTTankMetricOptionArmor];
    self.propertyObserveButton.selected = [WOTMetric options:self.metricOptions includesOption:WOTTankDetailPropertySelectionObserve];
    self.propertyFireButton.selected = [WOTMetric options:self.metricOptions includesOption:WOTTankDetailPropertySelectionFire];
    self.propertyMobilityButton.selected = [WOTMetric options:self.metricOptions includesOption:WOTTankDetailPropertySelectionMobility];
    [self updateUINeedReset:YES];
}

- (void)setVehicle:(Vehicles *)vehicle {

    if (_vehicle != vehicle) {
        
        _vehicle = vehicle;
        self.title = _vehicle.tanks.name_i18n;

        [self fetchPlayableVehiclesForTier:_vehicle.tier];
//        [self fetchDefaultConfigurationForTankId:[_vehicle.tank_id stringValue]];
    }
}

- (void)setViewMode:(WOTTankDetailViewMode)viewMode {

    if (viewMode != _viewMode) {
    
        _viewMode = viewMode;
    }
    
    self.viewModeGridButton.selected = (_viewMode == WOTTankDetailViewModeGrid);
    self.viewModeRadarButton.selected = (_viewMode == WOTTankDetailViewModeRadar);
    [self updateUINeedReset:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.radarViewController = [[WOTRadarViewController alloc] initWithNibName:NSStringFromClass([WOTRadarViewController class]) bundle:nil];
    [self.radarViewController setDelegate:self];

    self.gridViewController = [[WOTTankGridViewController alloc] initWithNibName:NSStringFromClass([WOTTankGridViewController class]) bundle:nil];
    [self.gridViewController setDelegate:self];
    
    self.metricOptions = WOTTankMetricOptionNone;
    self.viewMode = WOTTankDetailViewModeGrid;

    [self.configurationCustomButton setSelected:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];

    [self.topBar setDarkStyle];
    [self.bottomBar setDarkStyle];
}

- (void)updateUINeedReset:(BOOL)needReset {
    
    [NSThread executeOnMainThread:^{
        
        if ([self.viewContainerConstraints count] != 0) {
            
            [self.viewContainer removeConstraints:self.viewContainerConstraints];
            self.viewContainerConstraints = nil;
        }
        
        [self.viewContainer.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
            [subview removeFromSuperview];
        }];
        
        UIView *viewToAdd = nil;
        switch (self.viewMode) {
                
            case WOTTankDetailViewModeGrid:{
                
                viewToAdd = self.gridViewController.view;
                if (needReset) {
                    [self.gridViewController needToBeCleared];
                }
                [self.gridViewController reload];
                break;
            }
            case WOTTankDetailViewModeRadar :{

                viewToAdd = self.radarViewController.view;
                
                if (needReset) {
                    
                    [self.radarViewController needToBeCleared];
                }
                [self.radarViewController reload];

                break;
            }
        
            default: {
                break;
            }
        }
        
        if (viewToAdd) {
            
            [self.viewContainer addSubview:viewToAdd];
            self.viewContainerConstraints = [[viewToAdd addStretchingConstraints] copy];
        }
        
    }];
}

- (NSFetchedResultsController *)fetchedResultController {
    
    if (!_fetchedResultController) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"tanks.tank_id", self.tankId];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WOTCoreDataProvider sharedInstance] mainManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
    }
    return _fetchedResultController;
}

- (void)setTankId:(NSNumber *)tankId {
    
    if (![tankId isEqual:_tankId]) {
        
        _tankId = [tankId copy];
        
        NSString *requestId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_ITEM, self.tankId];
        [self refetchTankID:[_tankId stringValue] groupId:requestId];

        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
        self.fetchError = error;
        
        self.vehicle =  [self.fetchedResultController.fetchedObjects lastObject];
        
        
        /*
         * Default Profile
         */
        [self executeDefaultProfileRequestForTankId:[tankId stringValue]];
        
    }
}

- (void)setFetchError:(NSError *)fetchError {
    
    _fetchError = fetchError;
}


#pragma mark - private
//
//- (void)fetchDefaultConfigurationForTankId:(id)tankId {
//    
//    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
//    [args setObject:tankId forKey:WOT_KEY_TANK_ID];
//
//    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTankProfile];
//    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_VEHICLE_PROFILE];
//    if (canAdd) {
//        
//        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
//    }
//}

- (void)fetchPlayableVehiclesForTier:(id)tier {
    
    
    return;
    
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:@[tier]];
    
    NSArray *ids = [WOTTankIdsDatasource fetchForTiers:tiers nations:nil types:nil];
    [ids enumerateObjectsUsingBlock:^(NSNumber *tankId, NSUInteger idx, BOOL *stop) {
        
        NSString *groupId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_BY_TIER, tankId];
        if (!self.runningRequestIDs){
            
            self.runningRequestIDs = [[NSMutableSet alloc] init];
        }
        [self.runningRequestIDs addObject:groupId];
        [self refetchTankID:[tankId stringValue] groupId:groupId];
    }];
}

- (void)refetchTankID:(NSString *)tankID groupId:(id)groupId{

    if (!([tankID integerValue] > 0)) {
        
        debugError(@"tankID should not be nil");
        return;
    }
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:tankID forKey:WOT_KEY_TANK_ID];
    [args setObject:[[Vehicles availableFields] componentsJoinedByString:@","] forKey:WOT_KEY_FIELDS];

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTankVehicles];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:groupId];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
    }
}


- (void)executeDefaultProfileRequestForTankId:(id)tankId {
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:tankId forKey:WOT_KEY_TANK_ID];
    
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdTankProfile];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_VEHICLE_PROFILE];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
    }
}




#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 
    self.vehicle = [self.fetchedResultController.fetchedObjects lastObject];

    [self updateUINeedReset:NO];
}

#pragma mark -
- (void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)notification {
    
    /*
     Too complex
    
    NSPredicate *predicateClassVehicles = [NSPredicate predicateWithFormat: @"class == %@", [Vehicles class]];
    NSPredicate *predicateClassTanks = [NSPredicate predicateWithFormat: @"class == %@", [Tanks class]];
    NSCompoundPredicate *predicateClass = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateClassVehicles,predicateClassTanks]];
    NSPredicate *predicateTankId = [NSPredicate predicateWithFormat: @"%K == %@",WOT_KEY_TANK_ID, self.tankId];
    NSCompoundPredicate *predicate1 = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateClass, predicateTankId]];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat: @"class == %@", [Tankengines class]];
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2]];
    
    BOOL shouldRefresh = NO;
    NSSet *inserted = notification.userInfo[@"inserted"];
    shouldRefresh |= ([[inserted filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *updated = notification.userInfo[@"updated"];
    shouldRefresh |= ([[updated filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *created = notification.userInfo[@"created"];
    shouldRefresh |= ([[created filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *refreshed = notification.userInfo[@"refreshed"];
    shouldRefresh |= ([[refreshed filteredSetUsingPredicate:predicate] count] > 0);
    
    if (shouldRefresh) {
        
        [self updateUI];
    }
     
     */

    [self updateUINeedReset:NO];
    
}



#pragma mark - IBActions
- (IBAction)onConfigurationCustomSelection:(id)sender {
    
    self.configurationCustomButton.selected = YES;
    self.configurationDefaultButton.selected = NO;
    self.configurationTopButton.selected = NO;
    
    
    WOTTankModuleTreeViewController *configurationSelector = [[WOTTankModuleTreeViewController alloc] initWithNibName:NSStringFromClass([WOTTankModuleTreeViewController class]) bundle:nil];
    [configurationSelector setCancelBlock:^(){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [configurationSelector setDoneBlock:^(id configuration){
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    configurationSelector.tankId = self.tankId;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:configurationSelector];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (IBAction)onConfigurationTopSelection:(id)sender {
    
    self.configurationCustomButton.selected = NO;
    self.configurationDefaultButton.selected = NO;
    self.configurationTopButton.selected = YES;
}

- (IBAction)onConfigurationDefaultSelection:(id)sender {
    
    self.configurationCustomButton.selected = NO;
    self.configurationDefaultButton.selected = YES;
    self.configurationTopButton.selected = NO;
}

- (IBAction)onViewModeRadarSelection:(id)sender {
    
    self.viewMode = WOTTankDetailViewModeRadar;
}

- (IBAction)onViewModeGridSelection:(id)sender {
    
    self.viewMode = WOTTankDetailViewModeGrid;
}

- (IBAction)onPropertyArmorSelection:(id)sender {
    
    self.metricOptions = [WOTMetric options:self.metricOptions invertOption: WOTTankMetricOptionArmor];
}

- (IBAction)onPropertyFireSelection:(id)sender {

    self.metricOptions = [WOTMetric options:self.metricOptions invertOption: WOTTankDetailPropertySelectionFire];
}

- (IBAction)onPropertyMobilitySelection:(id)sender {

    self.metricOptions = [WOTMetric options:self.metricOptions invertOption: WOTTankDetailPropertySelectionMobility];
}

- (IBAction)onPropertyObserveSelection:(id)sender {
    
    self.metricOptions = [WOTMetric options:self.metricOptions invertOption: WOTTankDetailPropertySelectionObserve];
}

#pragma mark - WOTRadarViewControllerDelegate

- (RadarChartData *)radarData {
    
    WOTTankMetricsList *sample = [[WOTTankMetricsList alloc] init];
    [sample addTankID:[[WOTTanksIDList alloc] initWithId:self.tankId]];
    [sample addMetrics:[WOTMetric metricsForOption:self.metricOptions]];
    return sample.chartData;
}

#pragma mark - WOTGridViewControllerDelegate

- (id)gridData {
    
    NSArray *result = @[@{@"children":@{@"Lorem 1":@"1",@"Lorem 2":@"2"}, @"caption":@"Lorem"},
                        @{@"children":@{@"Lorem ips 1":@"1",@"\tLorem ips 2":@"3",@"\tLorem ips 3":@"3",@"\tLorem ips 4":@"4",@"\tLorem ips 11":@"11",@"Lorem ips 12":@"13",@"Lorem ips 13":@"13",@"Lorem ips 14":@"14"}, @"caption":@"Lorem ips"},
                        @{@"children":@{@"Lorem ips 101":@"101",@"Lorem ips 102":@"103",@"Lorem ips 103":@"103",@"Lorem ips 104":@"104",@"Lorem ips 1011":@"1011",@"Lorem ips 1012":@"1013",@"Lorem ips 1013":@"1013",@"Lorem ips 1014":@"1014"}, @"caption":@"Lorem ips"},
                        @{@"children":@{@"Lorem ips 201":@"201",@"Lorem ips 102":@"103",@"Lorem ips 103":@"103",@"Lorem ips 104":@"104",@"Lorem ips 2011":@"2011",@"Lorem ips 2012":@"2013",@"Lorem ips 2013":@"2013",@"Lorem ips 2014":@"2014"}, @"caption":@"Lorem ips"}
                        ];
    
    
    return result;
}

@end

//
//  WOTTankDetailViewController.m
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "NSObject+WOTTankGridValueData.h"
#import "UINavigationBar+WOT.h"
#import "UIToolbar+WOT.h"
#import "UIView+StretchingConstraints.h"
#import "WOTRadarViewController.h"
#import "WOTTankDetailViewController.h"
#import "WOTTankGridViewController.h"
#import "WOTTankModuleTreeViewController.h"
#import <ContextSDK/ContextSDK-Swift.h>
#import <WOTApi/WOTApi.h>
#import <WOTPivot/WOTPivot-Swift.h>
#import <WOTPivot/WOTPivot.h>

typedef NS_ENUM(NSUInteger, WOTTankDetailViewMode) {
    WOTTankDetailViewModeUnknown = 0,
    WOTTankDetailViewModeRadar = 1,
    WOTTankDetailViewModeGrid = 2
};

@interface WOTTankDetailViewController () <NSFetchedResultsControllerDelegate, WOTRadarViewControllerDelegate, WOTGridViewControllerDelegate, RequestManagerListenerProtocol>

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
@property (nonatomic, strong)WOTTankMetricOptions* metricOptions;
@property (nonatomic, strong)Vehicles *vehicle;
@property (nonatomic, strong)NSMutableSet *runningRequestIDs;
@property (nonatomic, strong) id<RequestManagerProtocol> requestManager;

@end

@implementation WOTTankDetailViewController

//@synthesize appContext;

#define WOT_REQUEST_ID_VEHICLE_ITEM @"WOT_REQUEST_ID_VEHICLE_ITEM"

- (void)dealloc {
    DeinitRequestCancelReason* reason = [[DeinitRequestCancelReason alloc] init];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSString *requestId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_ITEM, self.tankId];
    [self.requestManager cancelRequestsWithGroupId:requestId reason: reason];
    
    [self.runningRequestIDs enumerateObjectsUsingBlock:^(id requestID, BOOL *stop) {
        
        [self.requestManager cancelRequestsWithGroupId:requestID reason: reason];
    }];
    
    [self.runningRequestIDs removeAllObjects];
    
    self.fetchedResultController.delegate = nil;
    
    self.radarViewController.delegate = nil;
    self.radarViewController = nil;
//    self.nestedRequestsEvaluator = nil;
}

- (id)initWithContext:(id<ContextProtocol>)context {
    self = [super initWithNibName:NSStringFromClass([WOTTankDetailViewController class]) bundle:nil];
    if (self) {
//        self.appContext = context;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}

- (void)printModule:(ModulesTree *)module level:(NSInteger)level{

    NSSet *next = module.next_modules;
    [next enumerateObjectsUsingBlock:^(ModulesTree *nextModule, BOOL *stop) {
        
        [self printModule:nextModule level:(level+1)];
    }];
}

- (void)setMetricOptions:(WOTTankMetricOptions *)metricOptions {

    if (metricOptions.rawValue == WOTTankMetricOptions.none.rawValue) {
        
        if (_metricOptions.rawValue == WOTTankMetricOptions.none.rawValue) {
            
            _metricOptions = [WOTTankMetricOptions armor];
        } else {
            
            _metricOptions = [WOTTankMetricOptions none];
        }
    } else {
        
        _metricOptions = metricOptions;
    }
    
    self.propertyArmorButton.selected = [self.metricOptions isInclude:WOTTankMetricOptions.armor];
    self.propertyObserveButton.selected = [self.metricOptions isInclude:WOTTankMetricOptions.observe];
    self.propertyFireButton.selected = [self.metricOptions isInclude:WOTTankMetricOptions.fire];
    self.propertyMobilityButton.selected = [self.metricOptions isInclude:WOTTankMetricOptions.mobility];
    [self updateUINeedReset:YES];
}

- (void)setVehicle:(Vehicles *)vehicle {

    if (_vehicle != vehicle) {
        
        _vehicle = vehicle;
//        self.title = _vehicle.tanks.name_i18n;

        [self fetchPlayableVehiclesForTier:_vehicle.tier];
        [self fetchDefaultConfigurationForTankId:[_vehicle.tank_id stringValue]];
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
    
    [self setMetricOptions: WOTTankMetricOptions.none];
    [self setViewMode: WOTTankDetailViewModeGrid];

    [self.configurationCustomButton setSelected:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];

    [self.topBar setDarkStyle];
    [self.bottomBar setDarkStyle];
}

- (void)updateUINeedReset:(BOOL)needReset {
    
    [NSThread executeOnMainWithCompletion:^{
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"tank_id", self.tankId];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WOTApiFields.tank_id ascending:YES]];

        id<ContextProtocol> appDelegate = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
        id<DataStoreProtocol> coreDataProvider = appDelegate.dataStore;
        
        NSError *error = nil;
        _fetchedResultController = [coreDataProvider mainContextFetchResultControllerWithFetchRequest:fetchRequest sectionNameKeyPath:nil cacheName:nil error: &error];
        _fetchedResultController.delegate = self;
    }
    return _fetchedResultController;
}

- (void)setTankId:(NSNumber *)tankId {
    
    if (![tankId isEqual:_tankId]) {
        
        _tankId = [tankId copy];
        
        NSString *requestId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_ITEM, self.tankId];
        [self refetchTankID:[_tankId integerValue] groupId:requestId];

        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
        self.fetchError = error;
        
        self.vehicle =  [self.fetchedResultController.fetchedObjects lastObject];
        
        
        /*
         * Default Profile
         */
        [WOTWEBRequestFactory fetchProfileDataWithProfileTankId: [tankId integerValue]
                                                     appContext: [UIApplication sharedApplication].delegate
                                                       listener: self
                                                          error: &error];
    }
}

- (void)setFetchError:(NSError *)fetchError {
    
    _fetchError = fetchError;
}


#pragma mark - private

- (void)fetchDefaultConfigurationForTankId:(id)tankId {

    return;
//    WOTRequestArguments *arguments = [[WOTRequestArguments alloc] init];
//    [arguments setValues:@[tankId] forKey:WOTApiFields.tank_id];
//
//    id<WOTRequestProtocol> request = [[WOTRequestManager sharedInstance] createRequestForId:WOTRequestIdTankProfile];
//    BOOL canAdd = [[WOTRequestManager sharedInstance] add:request byGroupId:WGWebRequestGroups.vehicle_profile];
//    if (canAdd) {
//        [request start:arguments];
//    }
}

#define WOT_REQUEST_ID_VEHICLE_BY_TIER @"WOT_REQUEST_ID_VEHICLE_BY_TIER"

- (void)fetchPlayableVehiclesForTier:(id)tier {
    
    
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:@[tier]];
    
    NSArray *ids = [WOTTankIdsDatasource fetchForTiers:tiers nations:nil types:nil];
    [ids enumerateObjectsUsingBlock:^(NSNumber *tankId, NSUInteger idx, BOOL *stop) {
        
        NSString *groupId = [NSString stringWithFormat:@"%@:%@",WOT_REQUEST_ID_VEHICLE_BY_TIER, tankId];
        if (!self.runningRequestIDs){
            
            self.runningRequestIDs = [[NSMutableSet alloc] init];
        }
        [self.runningRequestIDs addObject:groupId];
        [self refetchTankID:[tankId integerValue] groupId:groupId];
    }];
}

- (void)refetchTankID:(NSInteger)tankID groupId:(id)groupId{

    NSError *error = nil;
    [WOTWEBRequestFactory fetchVehicleTreeDataWithVehicleId: tankID
                                                 appContext: [UIApplication sharedApplication].delegate
                                                   listener: self
                                                      error: &error];
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
    NSPredicate *predicateTankId = [NSPredicate predicateWithFormat: @"%K == %@",WOTApiFields.tankId, self.tankId];
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [configurationSelector setDoneBlock:^(id configuration){
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    configurationSelector.tank_Id = self.tankId;

    [self.navigationController pushViewController:configurationSelector animated:YES];
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
    
    self.metricOptions = [self.metricOptions inverted: WOTTankMetricOptions.armor];
}

- (IBAction)onPropertyFireSelection:(id)sender {

    self.metricOptions = [self.metricOptions inverted: WOTTankMetricOptions.fire];
}

- (IBAction)onPropertyMobilitySelection:(id)sender {

    self.metricOptions = [self.metricOptions inverted: WOTTankMetricOptions.mobility];
}

- (IBAction)onPropertyObserveSelection:(id)sender {
    
    self.metricOptions = [self.metricOptions inverted: WOTTankMetricOptions.observe];
}

//#pragma mark - WOTRadarViewControllerDelegate
//
//- (RadarChartData *)radarData {
//    
//    WOTTankMetricsList *sample = [[WOTTankMetricsList alloc] init];
//    [sample addTankID:[[WOTTanksIDList alloc] initWithId:self.tankId]];
//    [sample addMetrics:[WOTMetric metricsForOptions:self.metricOptions]];
//    return sample.chartData;
//}

#pragma mark - WOTGridViewControllerDelegate

- (PivotDataModel *)gridData {

    WOTTankMetricsList *sample = [[WOTTankMetricsList alloc] init];
    [sample addWithTankId:[[WOTTanksIDList alloc] initWithTankID: [self.tankId stringValue]]];
//    [sample addWithMetrics:[WOTMetric metricsForOptions:self.metricOptions]];
    return [NSObject gridData:sample];
}

//MARK: WOTRequestManagerListenerProtocol

- (NSString *)MD5 {
    return [MD5 MD5From:@"WOTTankDetailViewController"];
}

- (void)requestManager:(id<RequestManagerProtocol> _Nonnull)requestManager didParseDataForRequest:(id<RequestProtocol> _Nonnull)didParseDataForRequest error:(NSError * _Nullable)error {
    [self updateUINeedReset: YES];
    [requestManager removeListener:self];
}

- (void)requestManager:(id<RequestManagerProtocol> _Nonnull)requestManager didStartRequest:(id<RequestProtocol> _Nonnull)didStartRequest {
    //
}

- (void)requestManager:(id<RequestManagerProtocol>)requestManager didCancelRequest:(id<RequestProtocol>)didCancelRequest reason:(id<RequestCancelReasonProtocol>)reason {
    [requestManager removeListener:self];
}

@end

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

#import "WOTRequestExecutor.h"
#import "WOTTankDetailCollectionViewCell.h"
#import "WOTTankDetailCollectionReusableView.h"
#import "WOTTankDetailDatasource.h"
#import "WOTTankDetailCollectionViewFlowLayout.h"
#import "WOTTankConfigurationViewController.h"

#import "WOTTankIdsDatasource.h"

#import "WOTRadarViewController.h"
#import "WOTTankDetailSection+Factory.h"

@interface WOTTankDetailViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) WOTTankDetailDatasource *datasource;
@property (nonatomic, strong) NSError *fetchError;
@property (nonatomic, strong)Vehicles *vehicle;
@property (nonatomic, readonly)NSString *requestsGroupId;

@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[WOTRequestExecutor sharedInstance] cancelRequestsByGroupId:self.requestsGroupId];
    self.fetchedResultController.delegate = nil;
    self.datasource = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.datasource = [[WOTTankDetailDatasource alloc] init];
        [self.datasource addSection:[WOTTankDetailSection engineSection]];
        [self.datasource addSection:[WOTTankDetailSection chassisSection]];
        [self.datasource addSection:[WOTTankDetailSection turretsSection]];
        [self.datasource addSection:[WOTTankDetailSection radiosSection]];
        [self.datasource addSection:[WOTTankDetailSection gunsSection]];
    }
    return self;
}


- (NSString *)requestsGroupId {
    
    return [NSString stringWithFormat:@"vehicles:%@",self.tankId];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionReusableView class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class])];

    __weak typeof(self)weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *gearButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {


        WOTTankConfigurationViewController *configurationSelector = [[WOTTankConfigurationViewController alloc] initWithNibName:NSStringFromClass([WOTTankConfigurationViewController class]) bundle:nil];
        [weakSelf.navigationController pushViewController:configurationSelector animated:YES];
        
    }];

    [self.navigationItem setRightBarButtonItems:@[gearButtonItem]];

    [self.toolBar setDarkStyle];
}

- (void)setVehicle:(Vehicles *)vehicle {
    
    if (_vehicle != vehicle){

        _vehicle = vehicle;
        
        [self refetchPossibleTiersForTier:_vehicle.tier];
    }
    
}

- (void)updateUI {
    
    self.title = self.vehicle.tanks.name_i18n;
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
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

- (void)setTankId:(NSString *)tankId {
    
    _tankId = [tankId copy];
    [self refetchTankID:[self.tankId stringValue]];

    
    [self refetchCurrentVehicle];
}

- (void)setFetchError:(NSError *)fetchError {
    
    _fetchError = fetchError;
}

- (void)refetchTankID:(NSString *)tankID {

    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:tankID forKey:WOT_KEY_TANK_ID];
    [args setObject:[[Vehicles availableFields] componentsJoinedByString:@","] forKey:WOT_KEY_FIELDS];

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] requestById:WOTRequestIdTankVehicles];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:self.requestsGroupId];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:args];
    }
    
}

- (void)refetchCurrentVehicle {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    self.fetchError = error;
    
    self.vehicle = [self.fetchedResultController.fetchedObjects lastObject];
}

- (void)refetchPossibleTiersForTier:(NSNumber *)tier {
    
    NSArray *tiers = [WOTTankIdsDatasource availableTiersForTiers:@[tier]];
    
    NSArray *ids = [WOTTankIdsDatasource fetchForTiers:tiers nations:nil types:nil];
    [ids enumerateObjectsUsingBlock:^(NSNumber *tankId, NSUInteger idx, BOOL *stop) {
        
        [self refetchTankID:[tankId stringValue]];
    }];
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 
    self.vehicle = [self.fetchedResultController.fetchedObjects lastObject];
    [self updateUI];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self.datasource numberOfSections];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankDetailCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionReusableView class]) forIndexPath:indexPath];
    view.hasSubitems = ([self collectionView:collectionView numberOfItemsInSection:indexPath.section] > 0);
    [view setViewName:[self.datasource sectionNameAtIndex:indexPath.section]];
    return view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSString *query = [self.datasource queryAtSection:section];
    NSSet *fetchedObjects = [[self.fetchedResultController.fetchedObjects valueForKeyPath:query] lastObject];
    if (!fetchedObjects || ![fetchedObjects isKindOfClass:[NSSet class]]) {

        return 0;
    }
    
    id filteredObjects = [fetchedObjects allObjects];
    NSInteger cnt = [filteredObjects count];
    return cnt;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankDetailCollectionViewCell *result =(WOTTankDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class]) forIndexPath:indexPath];

    NSString *query = [self.datasource queryAtSection:indexPath.section];

    NSArray * fields = [self.datasource metricsInSecton:indexPath.section];

    id filteredObjects = [[[self.fetchedResultController.fetchedObjects valueForKeyPath:query] lastObject] allObjects];
    
    NSManagedObject *faultedObject = filteredObjects[indexPath.row];
    
    result.isLastInSection = (indexPath.row == ([self collectionView:collectionView numberOfItemsInSection:indexPath.section] - 1));
    result.fetchedObject = faultedObject;
    result.fields = fields;
    [result invalidate];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat separatorHeight = 1.0f;
    CGSize initialSize = [(WOTTankDetailCollectionViewFlowLayout *)collectionViewLayout itemSize];
    
    NSArray * fields = [self.datasource metricsInSecton:indexPath.section];
    CGSize result = [WOTTankDetailCollectionViewCell sizeFitSize:initialSize forFetchedObject:nil andFields:fields];
    
    return CGSizeMake(result.width, result.height + separatorHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize initialSize = [(WOTTankDetailCollectionViewFlowLayout *)collectionViewLayout headerReferenceSize];
    return initialSize;
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

    __weak typeof(self)weakSelf = self;
    BOOL isMain = [NSThread isMainThread];
    if (isMain) {
        
        [self updateUI];
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{

            [weakSelf updateUI];
        });
    }
}
@end

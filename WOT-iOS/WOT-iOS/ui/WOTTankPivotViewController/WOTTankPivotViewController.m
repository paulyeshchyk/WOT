//
//  WOTTankPivotViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotViewController.h"
#import "WOTTankPivotDataCollectionViewCell.h"
#import "WOTTankPivotFilterCollectionViewCell.h"
#import "WOTTankPivotFixedCollectionViewCell.h"
#import "WOTTankPivotEmptyCollectionViewCell.h"
#import "WOTTankPivotLayout.h"
#import "Tanks+DPM.h"
#import "WOTTankListSettingsDatasource.h"
#import "WOTNode+PivotFactory.h"

@interface WOTTankPivotViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankPivotLayout *flowLayout;

@property (nonatomic, strong) NSArray *fixedRowsTopLevel;
@property (nonatomic, strong) NSDictionary *fixedRowsChildren;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, readonly) NSArray *sortDescriptors;

@property (nonatomic, strong) WOTPivotDataModel *pivotDataModel;

@end

@implementation WOTTankPivotViewController

- (void)dealloc {
    
    self.fetchedResultController.delegate = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.flowLayout setRelativeContentSizeBlock:^CGSize{
        return self.pivotDataModel.dimension.contentSize;
    }];

    [self.flowLayout setItemRelativeRectCallback:^CGRect(NSIndexPath *indexPath) {
        return [self.pivotDataModel itemRectAtIndexPath:indexPath];
    }];

    [self.flowLayout setItemLayoutStickyType:^PivotStickyType(NSIndexPath *indexPath) {
        return [self.pivotDataModel itemStickyTypeAtIndexPath: indexPath];
    }];

    [self.navigationController.navigationBar setDarkStyle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class])];
    
    [self invalidateFetchedResultController];

    __weak typeof(self)weakSelf = self;

    NSArray * (^pivotItemCreation)(NSArray *predicates) = ^(NSArray *predicates){

        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];

        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        NSArray *fetchedData = [weakSelf.fetchedResultController.fetchedObjects filteredArrayUsingPredicate:predicate];
        [fetchedData enumerateObjectsUsingBlock:^(Tanks *tanks, NSUInteger idx, BOOL *stop) {

            id<WOTPivotNodeProtocol> node = [WOTNodeFactory pivotDataNodeForPredicate:predicate andTanksObject:tanks];
            [resultArray addObject:node];
        }];
        return resultArray;
    };

    self.pivotDataModel = [[WOTPivotDataModel alloc] initWithPivotItemCreation:pivotItemCreation];
    [self reloadPivot];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *result = nil;
    
    WOTPivotNodeSwift *node = (WOTPivotNodeSwift *)[self.pivotDataModel itemAtIndexPath:indexPath];
    if ([node isKindOfClass:[WOTPivotRowNodeSwift class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
        
        WOTTankPivotFixedCollectionViewCell *row = (WOTTankPivotFixedCollectionViewCell *)result;
        row.textValue = node.name;
    }
    
    if ([node isKindOfClass:[WOTPivotColNodeSwift class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
        
        WOTTankPivotFixedCollectionViewCell *fixed = (WOTTankPivotFixedCollectionViewCell *)result;
        fixed.textValue = node.name;
    }
    
    if ([node isKindOfClass:[WOTPivotFilterNodeSwift class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];
    }
    
    if ([node isKindOfClass:[WOTPivotDataNodeSwift class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) forIndexPath:indexPath];
        WOTTankPivotDataCollectionViewCell *dataCell = (WOTTankPivotDataCollectionViewCell *)result;
        dataCell.dataViewColor = node.dataColor;
        
        Tanks *tank = (Tanks *)node.data1;
        dataCell.symbol = node.name;
        dataCell.dpm = [tank.dpm suffixNumber];
        dataCell.mask = tank.invisibility;
        dataCell.visibility = [tank.visionRadius suffixNumber];
    }
    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.pivotDataModel itemsCountWithSection:section];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self reloadPivot];
}


#pragma mark - private
- (void)reloadPivot {

    [self.pivotDataModel clearMetadataItems];
    
    WOTPivotNodeSwift *level0Col = [WOTNodeFactory pivotTierMetadataItemAsType:PivotMetadataTypeColumn];
    WOTPivotNodeSwift *level1Col = nil;
    NSArray *cols = [self complexMetadataAsType:PivotMetadataTypeColumn forLevel0Node:level0Col level1Node:level1Col];
    
    WOTPivotNodeSwift *level0Row = [WOTNodeFactory pivotNationMetadataItemAsType:PivotMetadataTypeRow];
    WOTPivotNodeSwift *level1Row = nil;//[WOTNodeFactory pivotTypeMetadataItemAsType:PivotMetadataTypeRow];
    NSArray *rows = [self complexMetadataAsType:PivotMetadataTypeRow forLevel0Node:level0Row level1Node:level1Row];
    
    NSArray *filters = [self pivotFilters];

    [self.pivotDataModel addWithMetadataItems:filters];
    [self.pivotDataModel addWithMetadataItems:rows];
    [self.pivotDataModel addWithMetadataItems:cols];

    [self.pivotDataModel makePivot];
    
}

- (void)invalidateFetchedResultController {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    [fetchRequest setSortDescriptors:self.sortDescriptors];

    if (!self.fetchedResultController) {
        
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultController.delegate = self;
    }
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    
#warning !!!remove when dpm fetched
    NSArray *fetchedObjects = [self.fetchedResultController fetchedObjects];
    [fetchedObjects enumerateObjectsUsingBlock:^(Tanks *tank, NSUInteger idx, BOOL *stop) {
        {
//        debugLog(@"dpm:%@",tank.dpm);
//        debugLog(@"visionRadius:%@", tank.visionRadius);
//        debugLog(@"invisibility:%@", tank.invisibility);
//        debugLog(@"invisibilityShot:%@", tank.invisibilityShot);
//        debugLog(@"invisibilityImmobility:%@", tank.invisibilityImmobility);
//        debugLog(@"invisibilityMobility:%@", tank.invisibilityMobility);
//        debugLog(@"speed:%@", tank.speed);
//        debugLog(@"rotationSpeed:%@", tank.rotationSpeed);
//        debugLog(@"turretTraverseSpeed:%@", tank.turretTraverseSpeed);
//        debugLog(@"powerToWeightRatio:%@", tank.powerToWeightRatio);
//        debugLog(@"armor:%@", tank.armor);
//        debugLog(@"penetration:%@", tank.penetration);
//        debugLog(@"dispersion:%@", tank.dispersion);
//        debugLog(@"aimingTime:%@", tank.aimingTime);
        }
    }];
}

- (NSArray *)sortDescriptors {
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:[WOTTankListSettingsDatasource sharedInstance].sortBy];
    [result addObject:[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];
    
    return result;
}

#pragma mark - private
- (NSArray *)pivotFilters {
    WOTPivotFilterNodeSwift *node = [[WOTPivotFilterNodeSwift alloc] initWithName:@"Filter"];
    return @[node];
}

- (NSArray *)complexMetadataAsType:(PivotMetadataType)type forLevel0Node:(WOTPivotNodeSwift *)level0Node level1Node:(WOTPivotNodeSwift *)level1Node {

    Class PivotNodeClass = [WOTNodeFactory pivotNodeClassForType:type];

    WOTPivotNodeSwift *root = [[PivotNodeClass alloc] initWithName:@"-"];
    NSArray *level1Endpoints = level1Node.endpoints;
    NSArray *level0Endpoints = level0Node.endpoints;
    [level0Endpoints enumerateObjectsUsingBlock:^(WOTPivotNodeSwift *level0Child, NSUInteger idx, BOOL *stop) {

        WOTPivotNodeSwift *level0ChildCopy = [level0Child copy];
        [level1Endpoints enumerateObjectsUsingBlock:^(WOTPivotNodeSwift *level1Child, NSUInteger idx, BOOL *stop) {
            
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[level0Child.predicate, level1Child.predicate]];
            WOTPivotNodeSwift *level1ChildCopy = [level1Child copyWithZone:nil];
            level1ChildCopy.predicate = predicate;
            [level0ChildCopy addChild:level1ChildCopy];
        }];
        
        [root addChild:level0ChildCopy];
    }];
    
    return @[root];
}

@end

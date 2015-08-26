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
#import "WOTNode.h"
#import "Tanks+DPM.h"
#import "WOTTankListSettingsDatasource.h"
#import "WOTTree+Pivot.h"
#import "WOTNode+Pivot.h"
#import "WOTNode+PivotFactory.h"
#import "WOTNode+Enumeration.h"

@interface WOTTankPivotViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankPivotLayout *flowLayout;

@property (nonatomic, strong)NSArray *fixedRowsTopLevel;
@property (nonatomic, strong)NSDictionary *fixedRowsChildren;

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, readonly)NSArray *sortDescriptors;

@property (nonatomic, strong)WOTTree *pivotTree;

@end

@implementation WOTTankPivotViewController

- (void)dealloc {
    
    self.fetchedResultController.delegate = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self invalidateFetchedResultController];
    
    [self.flowLayout setRelativeContentSizeBlock:^(){
        
        return self.pivotTree.contentSize;
    }];
    
    [self.flowLayout setItemRelativeRectCallback:^CGRect(NSIndexPath *indexPath) {
       
        WOTNode *node = [self.pivotTree pivotItemAtIndexPath:indexPath];

        CGRect resultRect = node.relativeRect;
        return resultRect;
    }];
    
    [self.flowLayout setItemLayoutStickyType:^PivotStickyType(NSIndexPath *indexPath) {

        WOTNode *node = [self.pivotTree pivotItemAtIndexPath:indexPath];
        return node.stickyType;
    }];
    
    __weak typeof(self)weakSelf = self;

    WOTNode *level0Row =[WOTNode pivotNationMetadataItemAsType:PivotMetadataTypeRow];
    WOTNode *level1Row = nil;//[WOTNode pivotTypeMetadataItemAsType:PivotMetadataTypeRow];
    NSArray *rows = [self complexMetadataType:PivotMetadataTypeRow forLevel0Node:level0Row level1Node:level1Row];
    
    WOTNode *level0Col = [WOTNode pivotTierMetadataItemAsType:PivotMetadataTypeColumn];
    WOTNode *level1Col = nil;//[WOTNode pivotTypeMetadataItemAsType:PivotMetadataTypeColumn];
    NSArray *cols = [self complexMetadataType:PivotMetadataTypeColumn forLevel0Node:level0Col level1Node:level1Col];
    
    NSArray *filters = [self pivotFilters];
    
    self.pivotTree = [[WOTTree alloc] init];
    [self.pivotTree addMetadataItems:filters];
    [self.pivotTree addMetadataItems:rows];
    [self.pivotTree addMetadataItems:cols];
    
    [self.pivotTree setPivotItemCreationBlock:^NSArray *(NSArray *predicates) {
        
        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        NSArray *fetchedData = [weakSelf.fetchedResultController.fetchedObjects filteredArrayUsingPredicate:predicate];
        [fetchedData enumerateObjectsUsingBlock:^(Tanks *obj, NSUInteger idx, BOOL *stop) {

            NSURL *imageURL = [NSURL URLWithString:[obj image]];
            WOTNode *node = [[WOTNode alloc] initWithName:[obj short_name_i18n] imageURL:imageURL pivotMetadataType:PivotMetadataTypeData predicate:predicate];
            
            node.dataColor = [UIColor whiteColor];
            NSDictionary *colors = [WOTNode typeColors];

            node.dataColor = colors[obj.type];
            
            [node setData1:obj];
            [resultArray addObject:node];
        }];
        return resultArray;
    }];
    
    [self.pivotTree makePivot];
    
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class])];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *result = nil;
    
    WOTNode *node = [self.pivotTree pivotItemAtIndexPath:indexPath];
    switch (node.pivotMetadataType) {
        case PivotMetadataTypeColumn:{

            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];

            WOTTankPivotFixedCollectionViewCell *fixed = (WOTTankPivotFixedCollectionViewCell *)result;
            fixed.textValue = node.name;
//            fixed.hasBottomSeparator = NO;
//            fixed.hasRightSeparator = NO;
            
            break;
        }
        case PivotMetadataTypeRow:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
            
            WOTTankPivotFixedCollectionViewCell *row = (WOTTankPivotFixedCollectionViewCell *)result;
            row.textValue = node.name;
//            row.hasBottomSeparator = NO;
//            row.hasRightSeparator = NO;
            
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];

            break;
        }
        case PivotMetadataTypeData:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotDataCollectionViewCell *dataCell = (WOTTankPivotDataCollectionViewCell *)result;
            dataCell.dataViewColor = node.dataColor;

            Tanks *tank = (Tanks *)node.data1;
            dataCell.symbol = node.name;
            dataCell.dpm = [tank.dpm suffixNumber];
            dataCell.mask = tank.invisibility;
            dataCell.visibility = [tank.visionRadius suffixNumber];
            break;
        }
        default: {
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class]) forIndexPath:indexPath];
            break;
        }
    }

    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.pivotTree pivotItemsCountForRowAtIndex:section];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - private
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

        debugLog(@"dpm:%@",tank.dpm);
        debugLog(@"visionRadius:%@", tank.visionRadius);
        debugLog(@"invisibility:%@", tank.invisibility);
        debugLog(@"invisibilityShot:%@", tank.invisibilityShot);
        debugLog(@"invisibilityImmobility:%@", tank.invisibilityImmobility);
        debugLog(@"invisibilityMobility:%@", tank.invisibilityMobility);
        debugLog(@"speed:%@", tank.speed);
        debugLog(@"rotationSpeed:%@", tank.rotationSpeed);
        debugLog(@"turretTraverseSpeed:%@", tank.turretTraverseSpeed);
        debugLog(@"powerToWeightRatio:%@", tank.powerToWeightRatio);
        debugLog(@"armor:%@", tank.armor);
        debugLog(@"penetration:%@", tank.penetration);
        debugLog(@"dispersion:%@", tank.dispersion);
        debugLog(@"aimingTime:%@", tank.aimingTime);
        
    }];
}

- (NSArray *)sortDescriptors {
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:[WOTTankListSettingsDatasource sharedInstance].sortBy];
    [result addObject:[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];
    
    return result;
}

#pragma mark - private
- (NSArray *)pivotFilters {
    
    WOTNode *node = [[WOTNode alloc] initWithName:@"Filter" pivotMetadataType:PivotMetadataTypeFilter predicate:nil];
    return @[node];
}

- (NSArray *)complexMetadataType:(PivotMetadataType)type forLevel0Node:(WOTNode *)level0Node level1Node:(WOTNode *)level1Node {
    
//    NSMutableArray *result = [[NSMutableArray alloc] init];
    WOTNode *root = [[WOTNode alloc] initWithName:@"-" pivotMetadataType:type predicate:nil];
    [level0Node.endpoints enumerateObjectsUsingBlock:^(WOTNode *level0Child, NSUInteger idx, BOOL *stop) {
        
        WOTNode *level0ChildCopy = [[WOTNode alloc] initWithName:level0Child.name pivotMetadataType:level0Child.pivotMetadataType predicate:level0Child.predicate];
        [level1Node.endpoints enumerateObjectsUsingBlock:^(WOTNode *level1Child, NSUInteger idx, BOOL *stop) {
            
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[level0Child.predicate, level1Child.predicate]];
            WOTNode *nationCopy = [[WOTNode alloc] initWithName:level1Child.name pivotMetadataType:level1Child.pivotMetadataType predicate:predicate];
            [level0ChildCopy addChild:nationCopy];
        }];
        
        [root addChild:level0ChildCopy];
    }];
    
    return @[root];
}


@end

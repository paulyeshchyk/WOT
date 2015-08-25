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
#import "Tanks.h"
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

    WOTNode *level0Row =[WOTNode pivotTypeMetadataItemAsType:PivotMetadataTypeRow];
    WOTNode *level1Row = [WOTNode pivotTierMetadataItemAsType:PivotMetadataTypeRow];
    NSArray *rows = [self complexMetadataType:PivotMetadataTypeRow forLevel0Node:level0Row level1Node:level1Row];
    
    WOTNode *level0Col = [WOTNode pivotNationMetadataItemAsType:PivotMetadataTypeColumn];
    WOTNode *level1Col = [WOTNode pivotPremiumMetadataItemAsType:PivotMetadataTypeColumn];
    NSArray *cols = [self complexMetadataType:PivotMetadataTypeColumn forLevel0Node:level0Col level1Node:level1Col];
    
    
    self.pivotTree = [[WOTTree alloc] init];
    [self.pivotTree addMetadataItems:[self pivotFilters]];
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
            
//            [node setData1:obj];
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
            result.backgroundColor = [self.collectionView.backgroundColor lighterColor:1.3f];

            WOTTankPivotFixedCollectionViewCell *fixed = (WOTTankPivotFixedCollectionViewCell *)result;
            fixed.label.text = node.name;
            break;
        }
        case PivotMetadataTypeRow:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
            result.backgroundColor = [self.collectionView.backgroundColor lighterColor:1.3f];

            WOTTankPivotFixedCollectionViewCell *row = (WOTTankPivotFixedCollectionViewCell *)result;
            row.label.text = node.name;
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];
            result.backgroundColor = [self.collectionView.backgroundColor lighterColor:1.3f];
            break;
        }
        case PivotMetadataTypeData:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotDataCollectionViewCell *dataCell = (WOTTankPivotDataCollectionViewCell *)result;
            dataCell.dataViewColor = node.dataColor;

            dataCell.symbol = node.name;
            dataCell.dpm = [@(1787) suffixNumber];
            dataCell.mask = @"18/18/3";
            dataCell.visibility = @"450";
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
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [level0Node.endpoints enumerateObjectsUsingBlock:^(WOTNode *level0Child, NSUInteger idx, BOOL *stop) {
        
        WOTNode *level0ChildCopy = [[WOTNode alloc] initWithName:level0Child.name pivotMetadataType:level0Child.pivotMetadataType predicate:level0Child.predicate];
        [level1Node.endpoints enumerateObjectsUsingBlock:^(WOTNode *level1Child, NSUInteger idx, BOOL *stop) {
            
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[level0Child.predicate, level1Child.predicate]];
            WOTNode *nationCopy = [[WOTNode alloc] initWithName:level1Child.name pivotMetadataType:level1Child.pivotMetadataType predicate:predicate];
            [level0ChildCopy addChild:nationCopy];
        }];
        
        [result addObject:level0ChildCopy];
    }];
    
    return result;
}


@end

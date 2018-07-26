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
#import "Tanks+DPM.h"
#import "WOTTankListSettingsDatasource.h"
#import "WOTNode+PivotFactory.h"

@interface WOTTankPivotViewController(NodeCreator) <WOTNodeCreatorProtocol>
@end

@implementation WOTTankPivotViewController(NodeCreator)

- (id<WOTNodeProtocol> _Nonnull)createNodeWithName:(NSString * _Nonnull)name {
    id<WOTNodeProtocol> result = [[WOTNode alloc] initWithName: name];
    result.isVisible = false;
    return result;
}

- (id<WOTNodeProtocol> _Nonnull)createNodeWithFetchedObject:(id<NSFetchRequestResult> _Nullable)fetchedObject byPredicate:(NSPredicate * _Nullable)byPredicate {
    return [WOTNodeFactory pivotDataNodeForPredicate:byPredicate andTanksObject:fetchedObject];
}

@end

@interface WOTTankPivotViewController(WOTDataFetchControllerDelegateProtocol) <WOTDataFetchControllerDelegateProtocol>
@end

@implementation WOTTankPivotViewController(WOTDataFetchControllerDelegateProtocol)
@dynamic fetchRequest;

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest * result = [[NSFetchRequest alloc] initWithEntityName:@"Tanks"];
    result.sortDescriptors = [self sortDescriptors];
    result.predicate = [self fetchCustomPredicate];
    return result;
}

- (NSArray *) sortDescriptors {
    NSMutableArray *result = [[[WOTTankListSettingsDatasource sharedInstance] sortBy] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"tank_id" ascending:YES];
    [result addObject:descriptor];
    return result;
}

- (NSPredicate *) fetchCustomPredicate {
    NSPredicate *level6 = [NSPredicate predicateWithFormat:@"level == %d", 6];
    NSPredicate *level7 = [NSPredicate predicateWithFormat:@"level == %d", 7];
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[level6, level7]];
}

@end

@interface WOTTankPivotViewController () <UICollectionViewDataSource, WOTDataModelListener>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankPivotLayout *flowLayout;

@property (nonatomic, strong) NSArray *fixedRowsTopLevel;
@property (nonatomic, strong) NSDictionary *fixedRowsChildren;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, readonly) NSArray *sortDescriptors;

@property (nonatomic, strong) WOTPivotDataModel *model;
@property (nonatomic, strong) id<WOTDataFetchControllerProtocol> fetchController;


@end

@implementation WOTTankPivotViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.flowLayout setRelativeContentSizeBlock:^CGSize{
        return self.model.contentSize;
    }];

    [self.flowLayout setItemRelativeRectCallback:^CGRect(NSIndexPath *indexPath) {
        return [self.model itemRectAtIndexPath:indexPath];
    }];

    [self.flowLayout setItemLayoutStickyType:^PivotStickyType(NSIndexPath *indexPath) {
        id<WOTPivotNodeProtocol> node = [self.model itemAtIndexPath:indexPath];
        return node == nil ? PivotStickyTypeFloat : node.stickyType;
    }];

    [self.navigationController.navigationBar setDarkStyle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotEmptyCollectionViewCell class])];
    
    self.fetchController = [[WOTDataTanksFetchController alloc] initWithNodeFetchRequestCreator:self nodeCreator:self];
    self.model = [[WOTPivotDataModel alloc] initWithFetchController:self.fetchController modelListener:self nodeCreator:self];
    [self.model loadModel];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *result = nil;
    
    id<WOTPivotNodeProtocol> node = [self.model itemAtIndexPath:indexPath];
    if ([node isKindOfClass:[WOTPivotRowNode class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
        
        WOTTankPivotFixedCollectionViewCell *row = (WOTTankPivotFixedCollectionViewCell *)result;
        row.textValue = node.name;
    }
    
    if ([node isKindOfClass:[WOTPivotColNode class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
        
        WOTTankPivotFixedCollectionViewCell *fixed = (WOTTankPivotFixedCollectionViewCell *)result;
        fixed.textValue = node.name;
    }
    
    if ([node isKindOfClass:[WOTPivotFilterNode class]]) {
        
        result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];
    }
    
    if ([node isKindOfClass:[WOTPivotDataNode class]]) {
        
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

    return [self.model itemsCountWithSection:section];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<WOTPivotNodeProtocol> node = [self.model itemAtIndexPath:indexPath];
    if ([node isKindOfClass:[WOTPivotDataNode class]]) {
        Tanks* tank = (Tanks *)node.data1;
        WOTTankModuleTreeViewController *configurationSelector = [[WOTTankModuleTreeViewController alloc] initWithNibName:NSStringFromClass([WOTTankModuleTreeViewController class]) bundle:nil];
        configurationSelector.tankId = tank.tank_id;
        [configurationSelector setCancelBlock:^(){

            [self.navigationController popViewControllerAnimated:YES];
        }];
        [configurationSelector setDoneBlock:^(id configuration){

            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:configurationSelector animated:YES];
    }
}

#pragma mark - WOTPivotDataModelListener

- (void)modelDidLoad {
    [self.collectionView reloadData];
}

- (void)modelDidFailLoadWithError:(NSError * _Nonnull)error {

}

- (NSArray *)metadataItems {
    id<WOTPivotNodeProtocol> level0Col = [WOTNodeFactory pivotTierMetadataItemAsType:PivotMetadataTypeColumn];
    id<WOTPivotNodeProtocol> level1Col = nil;//[WOTNodeFactory pivotTypeMetadataItemAsType:PivotMetadataTypeColumn];
    NSArray *cols = [self complexMetadataAsType:PivotMetadataTypeColumn forLevel0Node:level0Col level1Node:level1Col];

    id<WOTPivotNodeProtocol> level0Row = [WOTNodeFactory pivotNationMetadataItemAsType:PivotMetadataTypeRow];
    id<WOTPivotNodeProtocol> level1Row = nil;
    NSArray *rows = [self complexMetadataAsType:PivotMetadataTypeRow forLevel0Node:level0Row level1Node:level1Row];

    NSArray *filters = [self pivotFilters];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:cols];
    [result addObjectsFromArray:rows];
    [result addObjectsFromArray:filters];
    return result;
}

- (NSArray *)pivotFilters {
    id<WOTPivotNodeProtocol> node = [[WOTPivotFilterNode alloc] initWithName:@"Filter"];
    return @[node];
}

- (NSArray *)complexMetadataAsType:(PivotMetadataType)type forLevel0Node:(id<WOTPivotNodeProtocol>  _Nullable )level0Node level1Node:(id<WOTPivotNodeProtocol>  _Nullable )level1Node {

    Class PivotNodeClass = [WOTNodeFactory pivotNodeClassForType:type];

    id<WOTPivotNodeProtocol> root = [[PivotNodeClass alloc] initWithName:@"-"];
    //TODO: isVisible == NO makes pivot invalid
    root.isVisible = YES;
    NSArray *level1Endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:level1Node];
    NSArray *level0Endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:level0Node];
    [level0Endpoints enumerateObjectsUsingBlock:^(id<WOTPivotNodeProtocol> level0Child, NSUInteger idx, BOOL *stop) {

        if (level0Child != nil) {

            id<WOTPivotNodeProtocol> level0ChildCopy = [level0Child copyWithZone:nil];
            [level1Endpoints enumerateObjectsUsingBlock:^(id<WOTPivotNodeProtocol> level1Child, NSUInteger idx, BOOL *stop) {

                if (level1Child != nil) {
                    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[level0Child.predicate, level1Child.predicate]];
                    id<WOTPivotNodeProtocol> level1ChildCopy = [level1Child copyWithZone:nil];
                    level1ChildCopy.predicate = predicate;
                    [level0ChildCopy addChild:level1ChildCopy];
                }
            }];

            [root addChild:level0ChildCopy];
        }
    }];

    return @[root];
}

@end

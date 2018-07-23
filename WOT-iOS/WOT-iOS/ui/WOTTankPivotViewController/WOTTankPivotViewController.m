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

@interface WOTTankPivotViewController(WOTDataFetchControllerDelegateProtocol) <WOTDataFetchControllerDelegateProtocol>
@end

@implementation WOTTankPivotViewController(WOTDataFetchControllerDelegateProtocol)
@dynamic fetchRequest;

- (id<WOTNodeProtocol> _Nonnull)createNodeWithFetchedObject:(id<NSFetchRequestResult> _Nonnull)fetchedObject byPredicate:(NSPredicate * _Nonnull)byPredicate {
    return [WOTNodeFactory pivotDataNodeForPredicate:byPredicate andTanksObject:fetchedObject];
}

- (NSFetchRequest *)fetchRequest {

    return [WOTTankPivotViewController fetchRequest];
}

+ (NSFetchRequest*) fetchRequest  {
    NSFetchRequest * result = [[NSFetchRequest alloc] initWithEntityName:@"Tanks"];
    result.sortDescriptors = [WOTTankPivotViewController sortDescriptors];
    result.predicate = [WOTTankPivotViewController fetchCustomPredicate];
    return result;
}

+ (NSArray *) sortDescriptors {
    NSMutableArray *result = [[[WOTTankListSettingsDatasource sharedInstance] sortBy] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"tank_id" ascending:YES];
    [result addObject:descriptor];
    return result;
}

+ (NSPredicate *) fetchCustomPredicate {

    NSPredicate *level10 = [NSPredicate predicateWithFormat:@"level == %d", 10];
    NSPredicate *level8 = [NSPredicate predicateWithFormat:@"level == %d", 8];
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[level10, level8]];
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
    
    self.fetchController = [[WOTDataTanksFetchController alloc] initWithDelegate: self];
    self.model = [[WOTPivotDataModel alloc] initWithFetchController: self.fetchController listener: self];
    [self.model loadModel];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *result = nil;
    
    WOTPivotNodeSwift *node = (WOTPivotNodeSwift *)[self.model itemAtIndexPath:indexPath];
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

    return [self.model itemsCountWithSection:section];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WOTPivotNodeSwift *node = (WOTPivotNodeSwift *)[self.model itemAtIndexPath:indexPath];
    if ([node isKindOfClass:[WOTPivotDataNodeSwift class]]) {
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
    WOTPivotNodeSwift *level0Col = [WOTNodeFactory pivotTierMetadataItemAsType:PivotMetadataTypeColumn];
    WOTPivotNodeSwift *level1Col = nil;//[WOTNodeFactory pivotTypeMetadataItemAsType:PivotMetadataTypeColumn];
    NSArray *cols = [self complexMetadataAsType:PivotMetadataTypeColumn forLevel0Node:level0Col level1Node:level1Col];

    WOTPivotNodeSwift *level0Row = [WOTNodeFactory pivotNationMetadataItemAsType:PivotMetadataTypeRow];
    WOTPivotNodeSwift *level1Row = nil;
    NSArray *rows = [self complexMetadataAsType:PivotMetadataTypeRow forLevel0Node:level0Row level1Node:level1Row];

    NSArray *filters = [self pivotFilters];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:cols];
    [result addObjectsFromArray:rows];
    [result addObjectsFromArray:filters];
    return result;
}

- (NSArray *)pivotFilters {
    WOTPivotFilterNodeSwift *node = [[WOTPivotFilterNodeSwift alloc] initWithName:@"Filter"];
    return @[node];
}


- (NSArray *)complexMetadataAsType:(PivotMetadataType)type forLevel0Node:(WOTPivotNodeSwift * _Nullable )level0Node level1Node:(WOTPivotNodeSwift  * _Nullable )level1Node {

    Class PivotNodeClass = [WOTNodeFactory pivotNodeClassForType:type];

    WOTPivotNodeSwift *root = [[PivotNodeClass alloc] initWithName:@"-"];
    NSArray *level1Endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:level1Node];
    NSArray *level0Endpoints = [WOTNodeEnumerator.sharedInstance endpointsWithNode:level0Node];
    [level0Endpoints enumerateObjectsUsingBlock:^(WOTPivotNodeSwift *level0Child, NSUInteger idx, BOOL *stop) {

        if (level0Child != nil) {

            WOTPivotNodeSwift *level0ChildCopy = [level0Child copy];
            [level1Endpoints enumerateObjectsUsingBlock:^(WOTPivotNodeSwift *level1Child, NSUInteger idx, BOOL *stop) {

                if (level1Child != nil) {
                    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[level0Child.predicate, level1Child.predicate]];
                    WOTPivotNodeSwift *level1ChildCopy = [level1Child copyWithZone:nil];
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

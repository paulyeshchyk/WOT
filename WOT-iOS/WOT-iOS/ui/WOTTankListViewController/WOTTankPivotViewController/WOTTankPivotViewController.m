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

    self.pivotTree = [[WOTTree alloc] init];
    [self.pivotTree addMetadataItems:[self pivotFilters]];
    [self.pivotTree addMetadataItems:[self complexRow]];
    [self.pivotTree addMetadataItems:[self complexCol]];
    
    [self.pivotTree setPivotItemCreationBlock:^NSArray *(NSArray *predicates) {
        
        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        NSArray *fetchedData = [weakSelf.fetchedResultController.fetchedObjects filteredArrayUsingPredicate:predicate];
        [fetchedData enumerateObjectsUsingBlock:^(Tanks *obj, NSUInteger idx, BOOL *stop) {

            NSURL *imageURL = [NSURL URLWithString:[obj image]];
            WOTNode *node = [[WOTNode alloc] initWithName:[obj short_name_i18n] imageURL:imageURL pivotMetadataType:PivotMetadataTypeData predicate:predicate];
            
            node.dataColor = [UIColor whiteColor];
            NSDictionary *colors = [weakSelf typeColors];

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

- (NSDictionary *)nationColors {
    
  return @{WOT_STRING_NATION_USA:     [[UIColor purpleColor] paleColor],
           WOT_STRING_NATION_USSR:    [[UIColor redColor] paleColor],
           WOT_STRING_NATION_JAPAN:   [[UIColor orangeColor] paleColor],
           WOT_STRING_NATION_CHINA:   [[UIColor yellowColor] paleColor],
           WOT_STRING_NATION_GERMANY: [[UIColor brownColor] paleColor],
           WOT_STRING_NATION_FRANCE:  [[UIColor greenColor] paleColor],
           WOT_STRING_NATION_UK:      [[UIColor blueColor] paleColor]};
}
- (NSDictionary *)typeColors {
    
    return @{WOT_STRING_TANK_TYPE_AT_SPG:       [[UIColor blueColor] paleColor],
             WOT_STRING_TANK_TYPE_SPG:          [[UIColor brownColor] paleColor],
             WOT_STRING_TANK_TYPE_LIGHT_TANK:   [[UIColor greenColor] paleColor],
             WOT_STRING_TANK_TYPE_MEDIUM_TANK:  [[UIColor yellowColor] paleColor],
             WOT_STRING_TANK_TYPE_HEAVY_TANK:   [[UIColor redColor] paleColor]};
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
//    [fetchRequest setPredicate:self.filterByPredicate];
    
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

- (NSArray *)pivotTypesMetadataItemsAsType:(PivotMetadataType)type {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_AT_SPG) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",WOT_STRING_TANK_TYPE_AT_SPG]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_SPG)    pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",WOT_STRING_TANK_TYPE_SPG]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",WOT_STRING_TANK_TYPE_LIGHT_TANK]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_MT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",WOT_STRING_TANK_TYPE_MEDIUM_TANK]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_HT)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",WOT_STRING_TANK_TYPE_HEAVY_TANK]]];
    return result;
}

- (NSArray *)pivotTypeMetadataItemsAsType:(PivotMetadataType)type {

    WOTNode *typeColumn = [[WOTNode alloc] initWithName:@"Type" pivotMetadataType:type predicate:nil];

    [typeColumn addChildArray:[self pivotTypesMetadataItemsAsType:type]];
    
    return @[typeColumn];
}

- (NSArray *)pivotPremiumsMetadataItemsAsType:(PivotMetadataType)type {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_IS_PREMIUM) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == YES",WOT_KEY_IS_PREMIUM]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_IS_NOT_PREMIUM) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"%K == NO",WOT_KEY_IS_PREMIUM]]];
    return result;
}

- (NSArray *)pivotPremiumMetadataItemsAsType:(PivotMetadataType)type {
    
    WOTNode *typeColumn = [[WOTNode alloc] initWithName:@"Premium" pivotMetadataType:type predicate:nil];
    [typeColumn addChildArray:[self pivotPremiumsMetadataItemsAsType:type]];
    
    return @[typeColumn];
}

- (NSArray *)pivotNationsMetadataItemsAsType:(PivotMetadataType)type {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_USA) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_USA]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_USSR)    pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_USSR]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_UK)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_UK]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_GERMANY)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_GERMANY]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_FRANCE)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_FRANCE]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_CHINA)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_CHINA]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_NATION_JAPAN)     pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"nation == %@",WOT_STRING_NATION_JAPAN]]];
    return result;
}

- (NSArray *)pivotNationMetadataItemsAsType:(PivotMetadataType)type {
    
    WOTNode *nationColumn = [[WOTNode alloc] initWithName:@"Nation" pivotMetadataType:type predicate:nil];
    
    [nationColumn addChildArray:[self pivotNationsMetadataItemsAsType:type]];
    
    return @[nationColumn];
}

- (NSArray *)pivotTiersMetadataItemsAsType:(PivotMetadataType)type {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_1)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_1]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_2)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_2]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_3)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_3]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_4)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_4]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_5)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_5]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_6)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_6]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_7)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_7]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_8)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_8]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_9)  pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_9]]];
    [result addObject:[[WOTNode alloc] initWithName:WOTString(WOT_STRING_LEVEL_10) pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %d",WOT_INTEGER_LEVEL_10]]];
    return result;
    
}

- (NSArray *)pivotTierMetadataItemsAsType:(PivotMetadataType)type {
    
    WOTNode *tierRow = [[WOTNode alloc] initWithName:@"Tier" pivotMetadataType:type predicate:nil];
    [tierRow addChildArray:[self pivotTiersMetadataItemsAsType:type]];
    
    return @[tierRow];
}

- (NSArray *)complexRow {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSArray *parents = [self pivotNationsMetadataItemsAsType:PivotMetadataTypeRow];
    NSArray *children = [self pivotTiersMetadataItemsAsType:PivotMetadataTypeRow];
 
    [parents enumerateObjectsUsingBlock:^(WOTNode *parent, NSUInteger idx, BOOL *stop) {
        
        WOTNode *tierCopy = [[WOTNode alloc] initWithName:parent.name pivotMetadataType:parent.pivotMetadataType predicate:parent.predicate];
        [children enumerateObjectsUsingBlock:^(WOTNode *child, NSUInteger idx, BOOL *stop) {
            
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[parent.predicate, child.predicate]];
            WOTNode *nationCopy = [[WOTNode alloc] initWithName:child.name pivotMetadataType:child.pivotMetadataType predicate:predicate];
            [tierCopy addChild:nationCopy];
        }];
        
        [result addObject:tierCopy];
    }];
    
    return result;
}


- (NSArray *)complexCol {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *parents = [self pivotTypesMetadataItemsAsType:PivotMetadataTypeColumn];
    NSArray *children = [self pivotPremiumsMetadataItemsAsType:PivotMetadataTypeColumn];
    
    [parents enumerateObjectsUsingBlock:^(WOTNode *parent, NSUInteger idx, BOOL *stop) {
        
        WOTNode *tierCopy = [[WOTNode alloc] initWithName:parent.name pivotMetadataType:parent.pivotMetadataType predicate:parent.predicate];
        [children enumerateObjectsUsingBlock:^(WOTNode *child, NSUInteger idx, BOOL *stop) {
            
            NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[parent.predicate, child.predicate]];
            WOTNode *nationCopy = [[WOTNode alloc] initWithName:child.name pivotMetadataType:child.pivotMetadataType predicate:predicate];
            [tierCopy addChild:nationCopy];
        }];
        
        [result addObject:tierCopy];
    }];
    
    return result;

}


@end

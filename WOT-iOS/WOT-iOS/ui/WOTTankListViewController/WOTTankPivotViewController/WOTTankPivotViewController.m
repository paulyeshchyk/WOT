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
    [self.pivotTree.rootRowsNode addChildArray:[self pivotRows]];
    [self.pivotTree.rootFiltersNode addChildArray:[self pivotFilters]];
    [self.pivotTree.rootColumnsNode addChildArray:[self pivotColumns]];
    
    [self.pivotTree setPivotItemCreationBlock:^NSArray *(NSArray *predicates) {
        
        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        NSArray *fetchedData = [weakSelf.fetchedResultController.fetchedObjects filteredArrayUsingPredicate:predicate];
        [fetchedData enumerateObjectsUsingBlock:^(Tanks *obj, NSUInteger idx, BOOL *stop) {

            NSURL *imageURL = [NSURL URLWithString:[obj image]];
            WOTNode *node = [[WOTNode alloc] initWithName:[obj name_i18n] imageURL:imageURL pivotMetadataType:PivotMetadataTypeData predicate:predicate];
            
            node.dataColor = [UIColor whiteColor];
            
            
            if ([obj.nation isEqualToString:@"usa"]) {
                
                node.dataColor = [UIColor purpleColor];
            }
            if ([obj.nation isEqualToString:@"ussr"]) {
                
                node.dataColor = [UIColor redColor];
            }
            if ([obj.nation isEqualToString:@"japan"]) {
                
                node.dataColor = [UIColor orangeColor];
            }
            if ([obj.nation isEqualToString:@"china"]) {
                
                node.dataColor = [UIColor yellowColor];
            }
            if ([obj.nation isEqualToString:@"germany"]) {
                
                node.dataColor = [UIColor brownColor];
            }
            if ([obj.nation isEqualToString:@"france"]) {
                
                node.dataColor = [UIColor greenColor];
            }
            if ([obj.nation isEqualToString:@"uk"]) {
                
                node.dataColor = [UIColor blueColor];
            }
            
            
            [node setData:obj];
            [resultArray addObject:node];
        }];
        return resultArray;
    }];
    
    [self.pivotTree makePivot];
    
    UIBarButtonItem *doneButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_APPLY) eventBlock:^(id sender) {
        
        if (self.doneBlock) {
            
            self.doneBlock(nil);
        }
    }];
    [self.navigationItem setRightBarButtonItems:@[doneButtonItem]];
    UIBarButtonItem *cancelButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_BACK) eventBlock:^(id sender) {
        
        if (self.cancelBlock) {
            
            self.cancelBlock();
        }
    }];
    [self.navigationItem setLeftBarButtonItems:@[cancelButtonItem]];
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
            fixed.label.text = node.name;
            break;
        }
        case PivotMetadataTypeRow:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotFixedCollectionViewCell *row = (WOTTankPivotFixedCollectionViewCell *)result;
            row.label.text = node.name;
            break;
        }
        case PivotMetadataTypeFilter:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];
            break;
        }
        case PivotMetadataTypeData:{
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotDataCollectionViewCell *dataCell = (WOTTankPivotDataCollectionViewCell *)result;
            dataCell.label.text = node.name;
            dataCell.dataViewColor = node.dataColor;
            
            [dataCell.imageView sd_setImageWithURL:node.imageURL];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
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
    
    WOTNode *node = [[WOTNode alloc] initWithName:@"Filter" pivotMetadataType:PivotMetadataTypeFilter predicate:nil];//[NSPredicate predicateWithFormat:@"nation == %@",@"usa"]
    return @[node];
}

- (NSArray *)pivotColumns {

    PivotMetadataType type = PivotMetadataTypeColumn;
    
    WOTNode *typeColumn = [[WOTNode alloc] initWithName:@"Type" pivotMetadataType:type predicate:nil];

    [typeColumn addChild:[[WOTNode alloc] initWithName:@"TD" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",@"AT-SPG"]]];
    [typeColumn addChild:[[WOTNode alloc] initWithName:@"SPG" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",@"SPG"]]];
    [typeColumn addChild:[[WOTNode alloc] initWithName:@"LT" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",@"lightTank"]]];
    [typeColumn addChild:[[WOTNode alloc] initWithName:@"MT" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",@"mediumTank"]]];
    [typeColumn addChild:[[WOTNode alloc] initWithName:@"HT" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"type == %@",@"heavyTank"]]];
    
    return @[typeColumn];
}

- (NSArray *)pivotRows {
    
    PivotMetadataType type = PivotMetadataTypeRow;

    WOTNode *tierRow = [[WOTNode alloc] initWithName:@"Tier" pivotMetadataType:type predicate:nil];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"I" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(1)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"II" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(2)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"III" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(3)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"IV" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(4)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"V" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(5)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"VI" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(6)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"VII" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(7)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"VIII" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(8)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"IX" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(9)]]];
    [tierRow addChild:[[WOTNode alloc] initWithName:@"X" pivotMetadataType:type predicate:[NSPredicate predicateWithFormat:@"level == %@",@(10)]]];

    return @[tierRow];
}

@end

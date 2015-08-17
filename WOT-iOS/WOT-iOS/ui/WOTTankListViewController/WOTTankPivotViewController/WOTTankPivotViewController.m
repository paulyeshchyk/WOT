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
#import "WOTTankPivotLayout.h"
#import "WOTNode.h"
#import "WOTPivotTemplate+Tanks.h"
#import "Tanks.h"
#import "WOTTankListSettingsDatasource.h"

@interface WOTTankPivotViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankPivotLayout *flowLayout;

@property (nonatomic, strong)NSArray *fixedRowsTopLevel;
@property (nonatomic, strong)NSDictionary *fixedRowsChildren;

@property (nonatomic, strong)WOTPivotTemplate *template;

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, readonly)NSArray *sortDescriptors;

@end

@implementation WOTTankPivotViewController

- (void)dealloc {
    
    self.fetchedResultController.delegate = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self invalidateFetchedResultController];
    
    __weak typeof(self)weakSelf = self;
    
    self.template = [[WOTPivotTemplate alloc] init];
    [self.template makeTanksDefaultPivot];
    [self.template setTemplateDataBlock:^NSArray *(id<WOTPivotMetaDataProtocol> column, id<WOTPivotMetaDataProtocol> row){

        NSMutableArray *subpredicates = [[NSMutableArray alloc] init];
        if (column.predicate) {
            
            [subpredicates addObject:column.predicate];
        }
        if (row.predicate) {
            
            [subpredicates addObject:row.predicate];
        }
        NSCompoundPredicate *metadataPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
        NSArray *resultArray = [weakSelf.fetchedResultController.fetchedObjects filteredArrayUsingPredicate:metadataPredicate];
        
        return resultArray;
    }];

    [self.template setTemplateDataReloadCompletionBlock:^{
       
        [weakSelf.collectionView reloadData];
    }];
    
    
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
    
    [self.template reload];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *result = nil;
    
    WOTPivotCellType cellType = [self.template cellTypeForRowAtIndexPath:indexPath];
    switch (cellType) {
        case WOTPivotCellTypeColumn: {
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotFixedCollectionViewCell *dataCell = (WOTTankPivotFixedCollectionViewCell *)result;
            dataCell.label.text = [self.template columnAtIndexPath:indexPath].name;
            break;
        }
        case WOTPivotCellTypeRow: {
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFixedCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotFixedCollectionViewCell *dataCell = (WOTTankPivotFixedCollectionViewCell *)result;
            dataCell.label.text = [self.template rowAtIndexPath:indexPath].name;
            break;
        }
        case WOTPivotCellTypeData: {
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotDataCollectionViewCell class]) forIndexPath:indexPath];
            WOTTankPivotDataCollectionViewCell *dataCell = (WOTTankPivotDataCollectionViewCell *)result;
            dataCell.label.text = @"lOrEm";
            break;
        }
        case WOTPivotCellTypeFilter: {
            
            result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotFilterCollectionViewCell class]) forIndexPath:indexPath];
            break;
        }
        default: {
            
            NSCAssert(NO, @"unknown cell type used");
            break;
        }
    }
    
    
    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.template cellsCountForRowAtIndex:section];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger rows = self.template.lastLevelRowsCount;
    NSInteger cols = self.template.colsDepth;
    
    return  rows + cols;
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

@end

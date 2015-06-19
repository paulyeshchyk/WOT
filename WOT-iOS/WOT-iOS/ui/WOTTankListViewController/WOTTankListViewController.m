//
//  WOTTankListViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListViewController.h"

#import "WOTRequestExecutor.h"
#import "WOTTankListSortViewController.h"

#import "Tanks.h"
#import "WOTTankListCollectionViewCell.h"
#import "WOTTankListCollectionViewHeader.h"
#import "WOTTankListSettingsDatasource.h"
#import "WOTTankDetailViewController.h"

@interface WOTTankListViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;

@property (nonatomic, readonly)NSArray *sortDescriptors;
@property (nonatomic, readonly)NSPredicate *filterBy;
@property (nonatomic, readonly)NSString *groupByField;

@end

@implementation WOTTankListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *settingsItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)] text:nil eventBlock:^(id sender) {
        
        
        WOTTankListSortViewController *vc = [[WOTTankListSortViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSortViewController class]) bundle:nil];
        vc.cancelBlock = ^(){
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        vc.commitBlock = ^(){
            
            [self invalidateFetchedResultController];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navigationItem setRightBarButtonItems:@[settingsItem]];

    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdTanks args:@{WOT_KEY_FIELDS:[[Tanks availableFields] componentsJoinedByString:@","]}];

    [self invalidateFetchedResultController];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListCollectionViewHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewHeader class])];
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.fetchedResultController.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankListCollectionViewCell *result = (WOTTankListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewCell class]) forIndexPath:indexPath];

    Tanks *tank = (Tanks *)[self.fetchedResultController objectAtIndexPath:indexPath];
    result.image = [tank image];
    result.tankName = tank.name_i18n;
    result.tankType = tank.type;
    result.level = [tank.level integerValue];
    return result;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    NSString *reuseIdentifier = NSStringFromClass([WOTTankListCollectionViewHeader class]);
    UICollectionReusableView *result = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:reuseIdentifier
                                                                                 forIndexPath:indexPath];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:indexPath.section];

    NSString *title = nil;
    if (([self.fetchedResultController.sectionNameKeyPath length] != 0) &&([sectionInfo.name length] != 0)) {
        
        title = [NSString stringWithFormat:@"%@: %@",WOTString(self.fetchedResultController.sectionNameKeyPath), sectionInfo.name];
    } else {
        
        title = sectionInfo.name;
        
    }
    
    [(WOTTankListCollectionViewHeader*)result setSectionName:title];
    return result;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_BACK)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    WOTTankDetailViewController *detail = [[WOTTankDetailViewController alloc] initWithNibName:NSStringFromClass([WOTTankDetailViewController class]) bundle:nil];
    Tanks *tank = [self.fetchedResultController objectAtIndexPath:indexPath];
    detail.tankId = tank.tank_id;

    [detail.navigationItem setLeftBarButtonItem:backButtonItem];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - private
- (void)invalidateFetchedResultController {

    self.fetchedResultController.delegate = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    [fetchRequest setSortDescriptors:self.sortDescriptors];
    [fetchRequest setPredicate:self.filterBy];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:self.groupByField cacheName:nil];
    self.fetchedResultController.delegate = self;
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    [self.collectionView reloadData];

}

- (NSPredicate *)filterBy {
    
    return [WOTTankListSettingsDatasource sharedInstance].filterBy;
}

- (NSArray *)sortDescriptors {
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:[WOTTankListSettingsDatasource sharedInstance].sortBy];
    [result addObject:[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];

    return result;
}

- (NSString *)groupByField {
    
    return [WOTTankListSettingsDatasource sharedInstance].groupBy;
}

@end

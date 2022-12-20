//
//  WOTTankListViewController.m
//  WOT-iOS
//
//  Created on 6/3/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListViewController.h"

#import "WOTTankListSortViewController.h"
#import <WOT-Swift.h>

#import <WOTData/WOTData.h>
#import "WOTTankListCollectionViewCell.h"
#import "WOTTankListCollectionViewHeader.h"
#import "WOTTankListSettingsDatasource.h"
#import "WOTTankDetailViewController.h"
#import "WOTTankListSearchBar.h"
#import "UIImage+Resize.h"
#import "UIBarButtonItem+EventBlock.h"

@interface WOTTankListViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, readonly) NSArray *sortDescriptors;
@property (nonatomic, readonly) NSPredicate *filterByPredicate;
@property (nonatomic, readonly) NSString *groupByField;
@property (nonatomic, strong) UIBarButtonItem *settingsItem;
@property (nonatomic, strong) UIBarButtonItem *searchItem;
@property (nonatomic, weak) WOTTankListSearchBar *searchBar;
@property (nonatomic, copy) NSArray *leftBarButtonItems;
@property (nonatomic, copy) NSString *searchBarText;
@property (nonatomic, strong) WOTTankListSettingsDatasource *settingsDatasource;

@end

@implementation WOTTankListViewController

@synthesize appManager;

- (void)dealloc {

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _settingsDatasource = [[WOTTankListSettingsDatasource alloc] init];
    
    __weak typeof(self)weakSelf = self;
    self.settingsItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)] text:nil eventBlock:^(id sender) {
        
        
        WOTTankListSortViewController *vc = [[WOTTankListSortViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSortViewController class]) bundle:nil];
        vc.cancelBlock = ^(){
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
        vc.commitBlock = ^(){
            
            [weakSelf invalidateFetchedResultController];
        };
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    self.searchItem = [UIBarButtonItem barButtonItemForImage:[self searchItemSearchImage] text:nil eventBlock:^(id sender) {

        if (self.searchBar) {

            [((UIButton *)self.searchItem.customView )setImage:[self searchItemSearchImage] forState:UIControlStateNormal];
            self.searchBarText = nil;
            [self invalidateFetchedResultController];
            [self restoreTitleViewState];
        } else {
            
            self.searchBar  = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([WOTTankListSearchBar class]) owner:self options:nil] lastObject];
            [self.searchBar setCommitBlock:^(NSString *text){

                self.searchBarText = text;
                [self invalidateFetchedResultController];
                [((UIButton *)self.searchItem.customView )setImage:[self searchItemCancelImage] forState:UIControlStateNormal];
            }];
            [self.searchBar setCloseBlock:^(){

                [self restoreTitleViewState];
                [((UIButton *)self.searchItem.customView )setImage:[self searchItemSearchImage] forState:UIControlStateNormal];

                self.searchBarText = nil;
                [self invalidateFetchedResultController];
            }];

            [self.searchBar becomeFirstResponder];
            
            [self saveTitleViewState];
            [self searchBarMakeVisible];
            [((UIButton *)self.searchItem.customView )setImage:[self searchItemCancelImage] forState:UIControlStateNormal];
        }
        
    }];
    
    [self.navigationItem setRightBarButtonItems:@[self.searchItem, self.settingsItem]];


    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListCollectionViewHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewHeader class])];
    
    [self invalidateFetchedResultController];
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self invalidateFetchedResultController];
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

    Vehicles *tank = (Vehicles *)[self.fetchedResultController objectAtIndexPath:indexPath];
//    result.image = [tank image];
    result.tankName = tank.name;
    result.tankType = tank.type;
    result.level = [tank.tier integerValue];
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

    __weak typeof(self)weakSelf = self;
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_BACK)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender){
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    WOTTankDetailViewController *detail = [[WOTTankDetailViewController alloc] initWithNibName:NSStringFromClass([WOTTankDetailViewController class]) bundle:nil];
    Vehicles *tank = [self.fetchedResultController objectAtIndexPath:indexPath];
    detail.tankId = tank.tank_id;

    [detail.navigationItem setLeftBarButtonItem:backButtonItem];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - private
- (void)invalidateFetchedResultController {

    self.fetchedResultController.delegate = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
    [fetchRequest setSortDescriptors:self.sortDescriptors];
    [fetchRequest setPredicate:self.filterByPredicate];
    
    id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
    id<DataStoreProtocol> coreDataProvider = appDelegate.dataStore;
    self.fetchedResultController = [coreDataProvider mainContextFetchResultControllerFor:fetchRequest sectionNameKeyPath:self.groupByField cacheName:nil];
    self.fetchedResultController.delegate = self;
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    [self.collectionView reloadData];

}

- (NSPredicate *)filterByPredicate {
    
    NSPredicate *filterByPredicate = _settingsDatasource.filterBy;
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    if (filterByPredicate){
        
        [predicates addObject:filterByPredicate];
    }
    
    if ([self.searchBarText length] != 0) {

        NSPredicate *searchBarPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@",WOTApiKeys.name, self.searchBarText];
        [predicates addObject:searchBarPredicate];
    }
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

- (NSArray *)sortDescriptors {
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:_settingsDatasource.sortBy];
    [result addObject:[NSSortDescriptor sortDescriptorWithKey:WOTApiKeys.tank_id ascending:YES]];

    return result;
}

- (NSString *)groupByField {
    
    return _settingsDatasource.groupBy;
}

#pragma mark - private
- (UIImage *)searchItemSearchImage {
    
    return [UIImage imageWithImage:[UIImage imageNamed:WOTString(WOT_IMAGE_SEARCH)] scaledToSize:CGSizeMake(22.0f,22.0f)];

}

- (UIImage *)searchItemCancelImage {
    
    return [UIImage imageWithImage:[UIImage imageNamed:WOTString(WOT_IMAGE_CANCEL)] scaledToSize:CGSizeMake(22.0f,22.0f)];
}

- (void)restoreTitleViewState {
    
    self.searchBarText = nil;
    self.navigationItem.titleView = nil;
    [self.navigationItem setRightBarButtonItems:@[self.searchItem,self.settingsItem]];
    [self.navigationItem setLeftBarButtonItems:self.leftBarButtonItems];
    self.searchBar = nil;
    self.leftBarButtonItems = nil;

}

- (void)saveTitleViewState {
    
    self.leftBarButtonItems = self.navigationItem.leftBarButtonItems;
}

- (void)searchBarMakeVisible {

//    CGSize size = self.navigationItem.titleView.bounds.size;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar setNeedsLayout];
    [self.navigationItem setLeftBarButtonItems:nil];
    [self.navigationItem setRightBarButtonItems:@[self.searchItem]];
}

@end

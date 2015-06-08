//
//  WOTTankListViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListViewController.h"
#import "WOTRequestExecutor+Registration.h"

#import "Tanks.h"
#import "WOTTankListCollectionViewCell.h"
#import "WOTTankListCollectionViewHeader.h"

@interface WOTTankListViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;

@property (nonatomic, readonly)NSArray *sortDescriptors;
@property (nonatomic, readonly)NSString *groupByField;
@property (nonatomic, readonly)NSArray *fieldsToFetch;

@property (nonatomic, assign) BOOL testSortDirection;


@end

@implementation WOTTankListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.testSortDirection = YES;
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdTanksList args:@{WOT_KEY_FIELDS:[self.fieldsToFetch componentsJoinedByString:@","]}];
    

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

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankListCollectionViewCell *result = (WOTTankListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankListCollectionViewCell class]) forIndexPath:indexPath];

    
    Tanks *tank = (Tanks *)[self.fetchedResultController objectAtIndexPath:indexPath];
    result.image = [tank image];
    return result;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    NSString *reuseIdentifier = NSStringFromClass([WOTTankListCollectionViewHeader class]);
    UICollectionReusableView *result = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:reuseIdentifier
                                                                                 forIndexPath:indexPath];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:indexPath.section];
    [(WOTTankListCollectionViewHeader*)result setSectionName:sectionInfo.name];
    return result;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    self.testSortDirection = !self.testSortDirection;

    [self invalidateFetchedResultController];
}

#pragma mark - private
- (void)invalidateFetchedResultController {
    
    self.fetchedResultController.delegate = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    [fetchRequest setSortDescriptors:self.sortDescriptors];
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:self.groupByField cacheName:nil];
    self.fetchedResultController.delegate = self;
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    [self.collectionView reloadData];
    
    
}

- (NSArray *)sortDescriptors {
    
    return @[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TYPE ascending:self.testSortDirection],[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_LEVEL ascending:YES]];
}

- (NSString *)groupByField {
    
    return WOT_KEY_NATION_I18N;
}

- (NSArray *)fieldsToFetch {
    
    return @[WOT_KEY_TANK_ID,WOT_KEY_NAME,WOT_KEY_IMAGE,WOT_KEY_CONTOUR_IMAGE,WOT_KEY_IMAGE_SMALL,WOT_KEY_IS_PREMIUM,WOT_KEY_LEVEL,WOT_KEY_NAME_I18N,WOT_KEY_NATION,WOT_KEY_NATION_I18N,WOT_KEY_SHORT_NAME_I18N,WOT_KEY_TYPE,WOT_KEY_TYPE_I18N ];
}

@end

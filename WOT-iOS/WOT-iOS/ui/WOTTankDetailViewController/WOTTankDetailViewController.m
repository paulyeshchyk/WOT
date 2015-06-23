//
//  WOTTankDetailViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/15/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailViewController.h"
#import "WOTRadarViewController.h"
#import "Tanks.h"
#import "Tankengines.h"
#import "Vehicles.h"

#import "WOTRequestExecutor.h"
#import "WOTTankDetailCollectionViewCell.h"
#import "WOTTankDetailCollectionReusableView.h"
#import "WOTTankDetailDatasource.h"

@interface WOTTankDetailViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIView *roseContainer;
@property (nonatomic, strong) WOTRadarViewController *roseDiagramController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) WOTTankDetailDatasource *datasource;
@property (nonatomic, strong) NSError *fetchError;

@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    _fetchedResultController.delegate = nil;
    self.datasource = nil;
    [self.roseDiagramController removeFromParentViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.datasource = [[WOTTankDetailDatasource alloc] init];
        self.roseDiagramController = [[WOTRadarViewController alloc] initWithNibName:NSStringFromClass([WOTRadarViewController class]) bundle:nil];
        [self addChildViewController:self.roseDiagramController];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *gearButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
        
    }];
    [self.navigationItem setRightBarButtonItems:@[gearButtonItem]];

    [self.roseContainer addSubview:self.roseDiagramController.view];
    [self.roseDiagramController.view addStretchingConstraints];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionReusableView class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class])];

}

- (NSFetchedResultsController *)fetchedResultController {
    
    if (!_fetchedResultController) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"tanks.tank_id", self.tankId];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];
        fetchRequest.returnsObjectsAsFaults = NO;
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WOTCoreDataProvider sharedInstance] mainManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate = self;
    }
    return _fetchedResultController;
}

- (void)setTankId:(NSString *)tankId {
    
    _tankId = [tankId copy];
    [self refetch];
}

- (void)setFetchError:(NSError *)fetchError {
    _fetchError = fetchError;
}

- (void)refetch {

    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:[self.tankId stringValue] forKey:WOT_KEY_TANK_ID];
    [args setObject:[[Vehicles availableFields] componentsJoinedByString:@","] forKey:WOT_KEY_FIELDS];
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdTankVehicles args:args];

    [self updateUI];
}

- (void)updateUI {
    
    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];
    self.fetchError = error;
    
    Vehicles *vehicles = [self.fetchedResultController.fetchedObjects lastObject];
    self.title = vehicles.tanks.name_i18n;
    
    
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 
    [self updateUI];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self.datasource numberOfSections];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankDetailCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionReusableView class]) forIndexPath:indexPath];
    [view setViewName:[self.datasource sectionNameAtIndex:indexPath.section]];
    return view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSString *query = [self.datasource queryAtSection:section];
    NSSet *fetchedObjects = [[self.fetchedResultController.fetchedObjects valueForKeyPath:query] lastObject];
    if (!fetchedObjects || ![fetchedObjects isKindOfClass:[NSSet class]]) {

        return 0;
    }
    
    id filteredObjects = [fetchedObjects allObjects];
    NSInteger cnt = [filteredObjects count];
    return cnt;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankDetailCollectionViewCell *result =(WOTTankDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class]) forIndexPath:indexPath];

    NSString *query = [self.datasource queryAtSection:indexPath.section];
    id filteredObjects = [[[self.fetchedResultController.fetchedObjects valueForKeyPath:query] lastObject] allObjects];

    NSArray * fields = [self.datasource fieldsInSecton:indexPath.section];
    result.fetchedObject = filteredObjects[indexPath.row];
    result.fields = fields;
    [result invalidate];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat separatorHeight = 1.0f;
    CGSize initialSize = CGSizeMake(320,32);
    
    NSArray * fields = [self.datasource fieldsInSecton:indexPath.section];
    CGSize result = [WOTTankDetailCollectionViewCell sizeFitSize:initialSize forFetchedObject:nil andFields:fields];
    
    return CGSizeMake(result.width, result.height + separatorHeight);
}

#pragma mark -
- (void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)notification {
    
    /*
     Too complex
    
    NSPredicate *predicateClassVehicles = [NSPredicate predicateWithFormat: @"class == %@", [Vehicles class]];
    NSPredicate *predicateClassTanks = [NSPredicate predicateWithFormat: @"class == %@", [Tanks class]];
    NSCompoundPredicate *predicateClass = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateClassVehicles,predicateClassTanks]];
    NSPredicate *predicateTankId = [NSPredicate predicateWithFormat: @"%K == %@",WOT_KEY_TANK_ID, self.tankId];
    NSCompoundPredicate *predicate1 = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateClass, predicateTankId]];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat: @"class == %@", [Tankengines class]];
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2]];
    
    BOOL shouldRefresh = NO;
    NSSet *inserted = notification.userInfo[@"inserted"];
    shouldRefresh |= ([[inserted filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *updated = notification.userInfo[@"updated"];
    shouldRefresh |= ([[updated filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *created = notification.userInfo[@"created"];
    shouldRefresh |= ([[created filteredSetUsingPredicate:predicate] count] > 0);
    NSSet *refreshed = notification.userInfo[@"refreshed"];
    shouldRefresh |= ([[refreshed filteredSetUsingPredicate:predicate] count] > 0);
    
    if (shouldRefresh) {
        
        [self updateUI];
    }
     
     */
    
    [self updateUI];
}
@end

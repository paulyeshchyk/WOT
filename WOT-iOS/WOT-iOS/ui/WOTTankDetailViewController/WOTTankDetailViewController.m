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

@interface WOTTankDetailViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)IBOutlet UIView *roseContainer;
@property (nonatomic, strong)WOTRadarViewController *roseDiagramController;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;


@end

@implementation WOTTankDetailViewController

- (void)dealloc {
    
    [self.roseDiagramController removeFromParentViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.roseDiagramController = [[WOTRadarViewController alloc] initWithNibName:NSStringFromClass([WOTRadarViewController class]) bundle:nil];
        [self addChildViewController:self.roseDiagramController];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
        
    }];
    [self.navigationItem setRightBarButtonItems:@[backButtonItem]];

    [self.roseContainer addSubview:self.roseDiagramController.view];
    [self.roseDiagramController.view addStretchingConstraints];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class])];
    
}

- (void)setTankId:(NSString *)tankId {
    
    _tankId = [tankId copy];
    [self refetch];
}


- (void)refetch {

    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setObject:[self.tankId stringValue] forKey:WOT_KEY_TANK_ID];
    [args setObject:[[Vehicles availableFields] componentsJoinedByString:@","] forKey:WOT_KEY_FIELDS];
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdTankVehicles args:args];
    
    
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",WOT_KEY_TANK_ID, self.tankId];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_TANK_ID ascending:YES]];
    
    if (!self.fetchedResultController) {
        
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WOTCoreDataProvider sharedInstance] mainManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultController.delegate = self;
    }
    [self.fetchedResultController performFetch:&error];
    
    Tanks *tanks = [self.fetchedResultController.fetchedObjects lastObject];
    self.title = tanks.name_i18n;
    
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 190;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *result =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankDetailCollectionViewCell class]) forIndexPath:indexPath];
    
    return result;
}
#pragma mark - UICollectionViewDelegate

@end

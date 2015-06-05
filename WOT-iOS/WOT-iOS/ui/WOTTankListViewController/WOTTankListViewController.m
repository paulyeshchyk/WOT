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

@interface WOTTankListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;

@end

@implementation WOTTankListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Tanks class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tank_id" ascending:YES]]];
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate = self;
    [self.fetchedResultController performFetch:&error];
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTWEBRequestTanksId args:@{WOT_KEY_FIELDS:@"tank_id,image,name"}];
    

}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

@end

//
//  WOTMenuDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMenuDatasource.h"
#import "UserSession.h"
#import "WOTSessionDataProvider.h"

#import "WOTProfileViewController.h"
#import "WOTTankListViewController.h"
#import "WOTPlayersListViewController.h"

@interface WOTMenuDatasource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *availableViewControllers;
@property (nonatomic, strong) NSArray *visibleViewControllers;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end

@implementation WOTMenuDatasource

- (id)init {

    self = [super init];
    if (self){
        

        self.availableViewControllers = [[NSMutableArray alloc] init];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTTankListViewController class] title:WOTString(WOT_STRING_TANKOPEDIA) image:nil userDependence:NO]];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTPlayersListViewController class] title:WOTString(WOT_STRING_PLAYERS) image:nil userDependence:NO]];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTProfileViewController class] title:WOTString(WOT_STRING_PROFILE) image:nil userDependence:YES]];

    
        NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([UserSession class])];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_EXPIRES_AT ascending:NO]]];
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultController.delegate = self;
        
        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
    
    }
    return self;
}

- (void)dealloc {

    self.fetchedResultController.delegate = nil;
}

- (void)rebuild {
    
    BOOL sessionHasBeenExpired = [WOTSessionDataProvider  sessionHasBeenExpired];
    if(sessionHasBeenExpired) {
        
        NSPredicate *predicate = nil;
        predicate = [NSPredicate predicateWithFormat:@"SELF.userDependence == NO"];
        self.visibleViewControllers = [self.availableViewControllers filteredArrayUsingPredicate:predicate];
    } else {
        
        self.visibleViewControllers = [self.availableViewControllers copy];
    }
}

- (void)setVisibleViewControllers:(NSArray *)visibleViewControllers {
    
    _visibleViewControllers = visibleViewControllers;
    [self.delegate hasUpdatedData:self];
}

- (NSInteger)objectsCount {
    
    return [self.visibleViewControllers count];
}

- (WOTMenuItem *)objectAtIndex:(NSInteger)index {
    
    return (WOTMenuItem *)(self.visibleViewControllers[index]);
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self rebuild];

}
@end



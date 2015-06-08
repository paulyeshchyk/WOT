//
//  WOTMenuViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTMenuViewController.h"
#import "WOTMenuTableViewCell.h"
#import "UserSession.h"

#import "WOTProfileViewController.h"
#import "WOTTankListViewController.h"
#import "WOTPlayersListViewController.h"
#import "WOTSessionDataProvider.h"
#import "WOTMenuDatasource.h"

@interface WOTMenuViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *availableViewControllers;
@property (nonatomic, strong) NSArray *visibleViewControllers;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) WOTMenuDatasource *menuDatasource;

@end

@implementation WOTMenuViewController
@synthesize selectedMenuItemClass;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.menuDatasource = [[WOTMenuDatasource alloc] init];
        
        self.availableViewControllers = [[NSMutableArray alloc] init];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTProfileViewController class] title:WOTString(WOT_STRING_PROFILE) image:nil userDependence:YES]];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTTankListViewController class] title:WOTString(WOT_STRING_TANKOPEDIA) image:nil userDependence:NO]];
        [self.availableViewControllers addObject:[[WOTMenuItem alloc] initWithClass:[WOTPlayersListViewController class] title:WOTString(WOT_STRING_PLAYERS) image:nil userDependence:NO]];
        
        self.selectedIndex = 0;

        [self rebuildVisibleControllers];
    }
    return self;
}

- (Class )selectedMenuItemClass {
    
    WOTMenuItem *item = (WOTMenuItem *)(self.visibleViewControllers[self.selectedIndex]);
    return item.controllerClass;
}

- (UIImage *)selectedMenuItemImage {
    
    WOTMenuItem *item = (WOTMenuItem *)(self.visibleViewControllers[self.selectedIndex]);
    return item.icon;
}

- (NSString *)selectedMenuItemTitle {
    
    WOTMenuItem *item = (WOTMenuItem *)(self.visibleViewControllers[self.selectedIndex]);
    return item.controllerTitle;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout:) name:WOT_NOTIFICATION_LOGOUT object:nil];
    
    self.visibleViewControllers = nil;
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([UserSession class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOT_KEY_EXPIRES_AT ascending:NO]]];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate = self;

    NSError *error = nil;
    [self.fetchedResultController performFetch:&error];

    [self.navigationController.navigationBar setDarkStyle];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTMenuTableViewCell class])];

    
    [self rebuildMenu];
    [self redrawNavigationBar];
    
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {

    _selectedIndex = selectedIndex;
    [self.delegate menu:self didSelectControllerClass:self.selectedMenuItemClass title:self.selectedMenuItemTitle image:self.selectedMenuItemImage];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.visibleViewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTMenuTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTMenuTableViewCell class]) forIndexPath:indexPath];
    WOTMenuItem *menuItem = self.visibleViewControllers[indexPath.row];
    result.cellTitle = menuItem.controllerTitle;
    result.cellImage = menuItem.icon;
    return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndex = indexPath.row;
}


#pragma mark - private

- (void)rebuildVisibleControllers {
    
    BOOL sessionHasBeenExpired = [WOTSessionDataProvider  sessionHasBeenExpired];
    if(sessionHasBeenExpired) {
        
        NSPredicate *predicate = nil;
        predicate = [NSPredicate predicateWithFormat:@"SELF.userDependence == NO"];
        self.visibleViewControllers = [self.availableViewControllers filteredArrayUsingPredicate:predicate];
    } else {
        
        self.visibleViewControllers = [self.availableViewControllers copy];
    }
}

- (void)rebuildMenu {

    [self rebuildVisibleControllers];
    
    [self.tableView reloadData];
    
    
}

- (void)redrawNavigationBar {
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_MENU_ICON)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
        
        [self.delegate loginPressedOnMenu:self];
    }];
    [self.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    [self.navigationItem setTitle:self.delegate.currentUserName];
}

#pragma mark - NSFetchedResultControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self rebuildMenu];
    [self redrawNavigationBar];
}

#pragma mark - NSNotification
- (void)onLogout:(NSNotification *)notification {
    
    [self rebuildMenu];
    [self redrawNavigationBar];
    self.selectedIndex = 0;
}

@end

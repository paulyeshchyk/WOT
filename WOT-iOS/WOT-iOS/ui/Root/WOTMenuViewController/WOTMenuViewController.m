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

@interface WOTMenuViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *availableViewControllers;
@property (nonatomic, strong)NSArray *availableTitles;
@property (nonatomic, strong)NSArray *availableImages;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;

@end

@implementation WOTMenuViewController
@synthesize selectedMenuItemClass;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.selectedIndex = 0;
        self.availableViewControllers = @[@"WOTProfileViewController",@"WOTTankListViewController",@"WOTPlayersListViewController"];
        self.availableTitles = @[WOTString(WOT_STRING_PROFILE),@"Tankopedia",@"Players"];
        self.availableImages = @[[NSNull null],[NSNull null],[NSNull null]];
        
    }
    return self;
}

- (NSString *)selectedMenuItemClass {
    
    return self.availableViewControllers[self.selectedIndex];
}

- (UIImage *)selectedMenuItemImage {
    
    return self.availableImages[self.selectedIndex];
}

- (NSString *)selectedMenuItemTitle {
    
    return self.availableTitles[self.selectedIndex];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSError *error = nil;
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([UserSession class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"expires_at" ascending:NO]]];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate = self;
    [self.fetchedResultController performFetch:&error];

    [self.navigationController.navigationBar setDarkStyle];
    
    [self redrawNavigationBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WOTMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"WOTMenuTableViewCell"];

}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.availableViewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTMenuTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:@"WOTMenuTableViewCell" forIndexPath:indexPath];
    result.cellTitle = self.availableTitles[indexPath.row];
    result.cellImage = self.availableImages[indexPath.row];
    return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndex = indexPath.row;
    [self.delegate menu:self didSelectControllerClass:self.selectedMenuItemClass title:self.selectedMenuItemTitle image:self.selectedMenuItemImage];
}


#pragma mark - private
- (void)redrawNavigationBar {
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_MENU_ICON)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:self.delegate.currentUserName eventBlock:^(id sender) {
        
        [self.delegate loginPressedOnMenu:self];
    }];
    [self.navigationItem setLeftBarButtonItems:@[backButtonItem]];
}

#pragma mark - NSFetchedResultControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self redrawNavigationBar];
}

@end

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

#import "WOTSessionDataProvider.h"
#import "WOTMenuDatasource.h"

@interface WOTMenuViewController () <UITableViewDataSource, UITableViewDelegate, WOTMenuDatasourceDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) WOTMenuDatasource *menuDatasource;

@end

@implementation WOTMenuViewController
@synthesize selectedMenuItemClass;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.menuDatasource = [[WOTMenuDatasource alloc] init];
        self.menuDatasource.delegate = self;
        [self.menuDatasource rebuild];
        self.selectedIndex = 0;
    }
    return self;
}

- (void)dealloc {
    
    self.menuDatasource.delegate = nil;
}

- (Class )selectedMenuItemClass {
    
    WOTMenuItem *item = [self.menuDatasource objectAtIndex:self.selectedIndex];
    return item.controllerClass;
}

- (UIImage *)selectedMenuItemImage {
    
    WOTMenuItem *item = [self.menuDatasource objectAtIndex:self.selectedIndex];
    return item.icon;
}

- (NSString *)selectedMenuItemTitle {
    
    WOTMenuItem *item = [self.menuDatasource objectAtIndex:self.selectedIndex];
    return item.controllerTitle;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTMenuTableViewCell class])];

    [self redrawNavigationBar];
    
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {

    _selectedIndex = selectedIndex;
    [self.delegate menu:self didSelectControllerClass:self.selectedMenuItemClass title:self.selectedMenuItemTitle image:self.selectedMenuItemImage];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.menuDatasource objectsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTMenuTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTMenuTableViewCell class]) forIndexPath:indexPath];
    WOTMenuItem *menuItem = [self.menuDatasource objectAtIndex:indexPath.row];
    result.cellTitle = menuItem.controllerTitle;
    result.cellImage = menuItem.icon;
    return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndex = indexPath.row;
}

#pragma mark - WOTMenuDatasourceDelegate
- (void)hasUpdatedData:(WOTMenuDatasource *)datasource {
    
    [self redrawNavigationBar];
    self.selectedIndex = 0;

    [self.tableView reloadData];
}

#pragma mark - private

- (void)redrawNavigationBar {

    [self.navigationController.navigationBar setDarkStyle];

    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_MENU_ICON)];
    UIBarButtonItem *backButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
        
        [self.delegate loginPressedOnMenu:self];
    }];
    [self.navigationItem setLeftBarButtonItems:@[backButtonItem]];
    [self.navigationItem setTitle:self.delegate.currentUserName];
}


@end

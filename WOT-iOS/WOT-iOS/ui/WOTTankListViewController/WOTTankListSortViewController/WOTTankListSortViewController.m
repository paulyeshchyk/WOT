//
//  WOTTankListSortViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSortViewController.h"
#import "WOTTankListSettingTableViewCell.h"
#import "WOTTankListSettingViewController.h"
#import "WOTTankListSortHeaderView.h"
#import "WOTTankListSettingsDatasource.h"

@interface WOTTankListSortViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;

@end

@implementation WOTTankListSortViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = WOTString(WOT_STRING_GROUP_AND_SORT);
    
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTString(WOT_IMAGE_BACK)] text:nil eventBlock:^(id sender) {
        if (self.cancelBlock){
            self.cancelBlock();
        }
        
    }];
    [self.navigationItem setLeftBarButtonItems:@[backItem]];

    UIBarButtonItem *applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_APPLY) eventBlock:^(id sender) {
        if (self.applyBlock){
            self.applyBlock();
        }
        
    }];
    [self.navigationItem setRightBarButtonItems:@[applyItem]];
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSortHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];

    
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[[WOTTankListSettingsDatasource sharedInstance] availableSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return [[[WOTTankListSettingsDatasource sharedInstance] objectsForSection:section] count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    ListSetting *obj = (ListSetting *)[[WOTTankListSettingsDatasource sharedInstance] objectsForSection:indexPath.section][indexPath.row];

//    WOTTankListSettingTableViewCell *result = (WOTTankListSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class]) forIndexPath:indexPath];
//    [result setSetting:obj];
//    return result;
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WOTTankListSortHeaderView *header = (WOTTankListSortHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];
    [header setText:[[WOTTankListSettingsDatasource sharedInstance] availableSections][section]];
    return header;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankListSettingViewController *vc = [[WOTTankListSettingViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSettingViewController class]) bundle:nil];
    vc.cancelBlock = ^(){
        
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    };
    vc.applyBlock = ^(){
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    };

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
    
}

@end

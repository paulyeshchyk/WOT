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
#import "ListSetting.h"

@interface WOTTankListSortViewController () <UITableViewDataSource, UITableViewDelegate, WOTTankListSettingsDatasourceListener>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, weak)UIBarButtonItem *backItem;

@end

@implementation WOTTankListSortViewController

- (void)dealloc {
    
    [[WOTTankListSettingsDatasource sharedInstance] unregisterListener:self];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = WOTString(WOT_STRING_GROUP_AND_SORT);
    
    self.backItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTString(WOT_IMAGE_BACK)] text:nil eventBlock:^(id sender) {
       
        if (self.cancelBlock){
            self.cancelBlock();
        }
    }];
    [self.navigationItem setLeftBarButtonItems:@[self.backItem]];

    UIBarButtonItem *applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_EDIT) eventBlock:^(id sender) {
        
        [self.tableView setEditing:!self.tableView.editing];
        [(UIButton *)sender setTitle:!self.tableView.editing?WOTString(WOT_STRING_EDIT):WOTString(WOT_STRING_PREVIEW) forState:UIControlStateNormal];
        [(UIButton *)sender sizeToFit];
        [self.backItem setEnabled:!self.tableView.editing];
    }];
    [self.navigationItem setRightBarButtonItems:@[applyItem]];
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSortHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];

    
    [[WOTTankListSettingsDatasource sharedInstance] registerListener:self];
    
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [WOTTankListSettingsDatasource sharedInstance].sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[WOTTankListSettingsDatasource sharedInstance] objectsCountForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ListSetting *obj = (ListSetting *)[[WOTTankListSettingsDatasource sharedInstance] objectAtIndexPath:indexPath];

    WOTTankListSettingTableViewCell *result = (WOTTankListSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class]) forIndexPath:indexPath];
    [result setSetting:obj];
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WOTTankListSortHeaderView *header = (WOTTankListSortHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];
    NSString *sectionName = [[WOTTankListSettingsDatasource sharedInstance] sectionNameAtIndex:section];
    [header setText:sectionName];
    return header;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    [[WOTTankListSettingsDatasource sharedInstance] moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return (sourceIndexPath.section == proposedDestinationIndexPath.section)?proposedDestinationIndexPath:sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[WOTTankListSettingsDatasource sharedInstance] removeObjectAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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

#pragma mark - WOTTankListSettingsDatasourceListener

- (void)willChangeContent {
    
//    [self.tableView beginUpdates];
}

- (void)didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
//    if (type == NSFetchedResultsChangeDelete) {
    
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

- (void)didChangeContent {
    
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

@end

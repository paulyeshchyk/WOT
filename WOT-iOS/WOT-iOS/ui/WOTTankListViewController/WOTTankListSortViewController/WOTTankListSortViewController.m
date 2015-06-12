//
//  WOTTankListSortViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSortViewController.h"
#import "WOTTankListSettingTableViewCell.h"
#import "WOTTankListSettingAddNewTableViewCell.h"
#import "WOTTankListSettingNameChooserViewController.h"
#import "WOTTankListSettingValueChangerViewController.h"
#import "WOTTankListSortHeaderView.h"
#import "ListSetting.h"
#import "WOTTankListSettingsDatasource+TableView.h"
#import "WOTTankListSettingsDatasource+AvailableFields.h"

@interface WOTTankListSortViewController () <UITableViewDataSource, UITableViewDelegate, WOTTankListSettingsDatasourceListener>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, weak)UIBarButtonItem *backItem;

@property (nonatomic, weak)id<WOTTableViewDatasourceProtocol> tableviewDatasource;

@end

@implementation WOTTankListSortViewController

- (void)dealloc {
    
    [self.tableviewDatasource rollback];
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
        [self.tableView reloadData];
    }];
    [self.navigationItem setRightBarButtonItems:@[applyItem]];
    [self.navigationController.navigationBar setDarkStyle];
    

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingAddNewTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingAddNewTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSortHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];

    
    [[WOTTankListSettingsDatasource sharedInstance] registerListener:self];
    
}

- (id<WOTTableViewDatasourceProtocol>)tableviewDatasource {
    
    return [WOTTankListSettingsDatasource sharedInstance];
}

- (id<WOTTankListSettingsAvailableFieldsProtocol>)availableFieldsDatasource {
    
    return [WOTTankListSettingsDatasource sharedInstance];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.tableviewDatasource.availableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger additionalRow = tableView.isEditing?0:1;
    return additionalRow + [self.tableviewDatasource objectsCountForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger objsCount = [self.tableviewDatasource objectsCountForSection:indexPath.section];
    if (indexPath.row >= objsCount) {
        
        WOTTankListSettingAddNewTableViewCell *result = (WOTTankListSettingAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingAddNewTableViewCell class]) forIndexPath:indexPath];
        return result;
    } else {
        
        ListSetting *obj = (ListSetting *)[self.tableviewDatasource objectAtIndexPath:indexPath];

        WOTTankListSettingTableViewCell *result = (WOTTankListSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingTableViewCell class]) forIndexPath:indexPath];
        [result setSetting:obj];
        return result;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WOTTankListSortHeaderView *header = (WOTTankListSortHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WOTTankListSortHeaderView class])];
    NSString *sectionName = [self.tableviewDatasource sectionNameAtIndex:section];
    [header setText:sectionName];
    return header;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger objsCount = [self.tableviewDatasource objectsCountForSection:indexPath.section];
    return (indexPath.row <objsCount);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    [self.tableviewDatasource moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return (sourceIndexPath.section == proposedDestinationIndexPath.section)?proposedDestinationIndexPath:sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableviewDatasource removeObjectAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WOTTankListSettingViewController *vc = nil;
    WOTTankListSettingType settingType = [self.tableviewDatasource settingTypeForSectionAtIndex:indexPath.section];

    switch (settingType) {
        case WOTTankListSettingTypeNameSelector: {
            
            vc = [[WOTTankListSettingNameChooserViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSettingNameChooserViewController class]) bundle:nil];
            break;
        }
        case WOTTankListSettingTypeValueChanger :{
            
            vc = [[WOTTankListSettingValueChangerViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSettingValueChangerViewController class]) bundle:nil];
        }
        default: {
            
            break;
        }
    }

    vc.availableFieldsDatasource = self.availableFieldsDatasource;
    vc.tableViewDatasource = self.tableviewDatasource;
    vc.sectionName = self.tableviewDatasource.availableSections[indexPath.section];
    vc.setting = [self.tableviewDatasource objectAtIndexPath:indexPath];
    
    vc.cancelBlock = ^(){
        
        [self.tableviewDatasource rollback];
        [self.navigationController popViewControllerAnimated:YES];
    };
    vc.applyBlock = ^(){

        [self.tableviewDatasource save];
        [self.navigationController popViewControllerAnimated:YES];
    };

    [self.navigationController pushViewController:vc animated:YES];
    
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

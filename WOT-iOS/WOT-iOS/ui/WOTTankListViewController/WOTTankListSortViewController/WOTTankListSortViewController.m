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
#import <WOTData/WOTData.h>
#import "WOTTankListSettingsDatasource+TableView.h"
#import "WOTTankListSettingsDatasource+AvailableFields.h"
#import "UINavigationBar+WOT.h"
#import "UIBarButtonItem+EventBlock.h"

@interface WOTTankListSortViewController () <UITableViewDataSource, UITableViewDelegate, WOTTankListSettingsDatasourceListener>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong)UIBarButtonItem *backItem;

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
    
    __weak typeof(self)weakSelf = self;
    self.backItem =  [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTString(WOT_IMAGE_BACK)] text:nil eventBlock:^(id sender) {
       
        if (weakSelf.cancelBlock){
            
            weakSelf.cancelBlock();
        }
    }];
    [self.navigationItem setLeftBarButtonItems:@[self.backItem]];

    UIBarButtonItem *applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_REORDER) eventBlock:^(id sender) {
        
        [weakSelf.tableView setEditing:!weakSelf.tableView.editing];
        [(UIButton *)sender setTitle:!weakSelf.tableView.editing?WOTString(WOT_STRING_REORDER):WOTString(WOT_STRING_PREVIEW) forState:UIControlStateNormal];
        [(UIButton *)sender sizeToFit];
        [weakSelf.backItem setEnabled:!weakSelf.tableView.editing];
        [weakSelf.tableView reloadData];
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

- (id<WOTTankListSettingsAvailableFieldsProtocol>)staticFieldsDatasource {
    
    return [WOTTankListSettingsDatasource sharedInstance];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.tableviewDatasource.availableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger additionalRow = 0;
    NSInteger objectsCount = [self.tableviewDatasource objectsCountForSection:section];

    switch (section) {
//        case 0:{
//            
//            break;
//        }
        case 1:{

            additionalRow = tableView.isEditing?0:((objectsCount == 0)?1:0);
            break;
        }
//        case 2:{
//            
//            break;
//        }
        default: {
            
            additionalRow = tableView.isEditing?0:1;
            break;
        }
    }
    return additionalRow + objectsCount;
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
    return (indexPath.row < objsCount);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    [self.tableviewDatasource moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath completionBlock:^{
        
        if (self.commitBlock){
            
            self.commitBlock();
        }
    }];
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
            [(WOTTankListSettingNameChooserViewController *)vc setHasSorting:YES];
            vc.title = [WOTString(WOT_STRING_CHANGE_SORTING) capitalizedString];
            break;
        }
        case WOTTankListSettingTypeGroupSelector :{
            
            vc = [[WOTTankListSettingNameChooserViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSettingNameChooserViewController class]) bundle:nil];
            [(WOTTankListSettingNameChooserViewController *)vc setHasSorting:NO];
            vc.title = [WOTString(WOT_STRING_CHANGE_GROUP) capitalizedString];
            break;
        }
        case WOTTankListSettingTypeValueChanger :{
            
            vc = [[WOTTankListSettingValueChangerViewController alloc] initWithNibName:NSStringFromClass([WOTTankListSettingValueChangerViewController class]) bundle:nil];
            vc.title = [WOTString(WOT_STRING_CHANGE_FILTER) capitalizedString];
            break;
        }
        default: {
            
            break;
        }
    }

    vc.staticFieldsDatasource = self.staticFieldsDatasource;
    vc.tableViewDatasource = self.tableviewDatasource;
    vc.sectionName = self.tableviewDatasource.availableSections[indexPath.section];
    vc.setting = [self.tableviewDatasource objectAtIndexPath:indexPath];
    
    vc.cancelBlock = ^(){
        
        [self.tableviewDatasource rollback];
        [self.navigationController popViewControllerAnimated:YES];
    };
    vc.applyBlock = ^(){

        [self.tableviewDatasource save];

        if (self.commitBlock) {
            self.commitBlock();
        }
        
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

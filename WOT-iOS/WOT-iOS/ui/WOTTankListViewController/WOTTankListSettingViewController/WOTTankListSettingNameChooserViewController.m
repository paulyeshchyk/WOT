//
//  WOTTankListSettingNameChooserViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingNameChooserViewController.h"
#import "WOTTankListSettingNameTableViewCell.h"
#import "WOTTankListSettingField.h"

@interface WOTTankListSettingNameChooserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation WOTTankListSettingNameChooserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingNameTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingNameTableViewCell class])];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    id key = [self.tableViewDatasource keyForSetting:self.setting];
    __block NSInteger index =  -1;
    [self.availableFieldsDatasource.availableFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[obj key] isEqualToString:key]) {
            
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index >= 0) {
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.availableFieldsDatasource.availableFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WOTTankListSettingField *field = self.availableFieldsDatasource.availableFields[indexPath.row];
    
    WOTTankListSettingNameTableViewCell *cell = (WOTTankListSettingNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingNameTableViewCell class]) forIndexPath:indexPath];
    [cell setText:WOTString(field.key)];
    [cell setKey:field.key];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    WOTTankListSettingField *field = self.availableFieldsDatasource.availableFields[indexPath.row];
    self.setting = [self.tableViewDatasource updateSetting:self.setting byType:self.sectionName byValue:field.key filterValue:nil callback:^(id setting) {
        
        self.setting = setting;
    }];
}

@end

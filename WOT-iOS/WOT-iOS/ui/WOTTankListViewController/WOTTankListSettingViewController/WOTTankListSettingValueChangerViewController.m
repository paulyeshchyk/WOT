//
//  WOTTankListSettingValueChangerViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingValueChangerViewController.h"
#import "ListSetting.h"
#import "WOTTankListSettingField.h"
#import "WOTTankListSettingNameTableViewCell.h"

@interface WOTTankListSettingValueChangerViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation WOTTankListSettingValueChangerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.canApply = NO;
    
    [self.textField setEnabled:(self.setting!= nil)];
    [self.textField setText:[(ListSetting *)self.setting values]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingNameTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingNameTableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    id key = [self.tableViewDatasource keyForSetting:self.setting];
    __block NSInteger index =  -1;
    [self.staticFieldsDatasource.allFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[obj key] isEqualToString:key]) {
            
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index >= 0) {
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (void)setSetting:(id)setting {
    
    [super setSetting:setting];
    [self.textField setEnabled:(self.setting != nil)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.staticFieldsDatasource.allFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[indexPath.row];
    
    WOTTankListSettingNameTableViewCell *cell = (WOTTankListSettingNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingNameTableViewCell class]) forIndexPath:indexPath];
    [cell setText:WOTString(field.key)];
    [cell setKey:field.key];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self)weakSelf = self;
    WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[indexPath.row];
    [self.tableViewDatasource updateSetting:self.setting byType:self.sectionName byValue:field.key filterValue:self.textField.text ascending:NO callback:^(id setting) {
        
        weakSelf.setting = setting;
        [weakSelf.textField setText:nil];
        weakSelf.canApply = NO;
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];
    
    __weak typeof(self)weakSelf = self;
    WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[[self.tableView.indexPathForSelectedRow row]];
    [self.tableViewDatasource updateSetting:self.setting byType:self.sectionName byValue:field.key filterValue:self.textField.text  ascending:NO callback:^(id setting) {
        
        weakSelf.setting = setting;
        weakSelf.canApply = ([[weakSelf.textField text] length] != 0);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
@end

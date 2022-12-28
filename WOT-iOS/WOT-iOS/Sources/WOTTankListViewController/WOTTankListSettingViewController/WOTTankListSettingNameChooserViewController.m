//
//  WOTTankListSettingNameChooserViewController.m
//  WOT-iOS
//
//  Created on 6/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingNameChooserViewController.h"
#import "WOTTankListSettingSortTableViewCell.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>

@interface WOTTankListSettingNameChooserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation WOTTankListSettingNameChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self){
    
        self.hasSorting = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListSettingSortTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListSettingSortTableViewCell class])];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

}

#pragma mark - private
- (NSInteger)indexForSetting:(id)setting {

    __block NSInteger result = -1;

    id key = [self.tableViewDatasource keyForSetting:self.setting];
    [self.staticFieldsDatasource.allFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[obj key] isEqualToString:key]) {
            
            result = idx;
            *stop = YES;
        }
    }];
    
    
    return result;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.staticFieldsDatasource.allFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[indexPath.row];
    
    WOTTankListSettingSortTableViewCell *cell = (WOTTankListSettingSortTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListSettingSortTableViewCell class]) forIndexPath:indexPath];
    [cell setHasSorting:self.hasSorting];
    [cell setText:[NSString localization:field.key]];
    [cell setKey:field.key];
    [cell setBusy:[self.staticFieldsDatasource isFieldBusy:field]];
    [cell setSortClick:^(BOOL ascending){
        
        WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[indexPath.row];
        [self.tableViewDatasource updateSetting:self.setting byType:self.sectionName byValue:field.key filterValue:nil ascending:ascending callback:^(id setting) {

            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }];

        
    }];
    
    NSNumber *ascending = [self.setting performSelector:@selector(ascending)];
    [cell setAscending:[ascending boolValue]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index =  [self indexForSetting:self.setting];
    cell.selected = (index == indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    WOTTankListSettingField *field = self.staticFieldsDatasource.allFields[indexPath.row];
    [self.tableViewDatasource updateSetting:self.setting byType:self.sectionName byValue:field.key filterValue:nil ascending:field.ascending callback:^(id setting) {
        
        self.setting = setting;
        [tableView reloadData];
    }];
}

@end

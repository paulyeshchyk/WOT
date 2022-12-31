//
//  WOTTankListCompoundViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListCompoundViewController.h"
#import "WOTTankListCompoundViewTableViewCell.h"
#import "WOTTankListSettingViewController.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>
#import "UIBarButtonItem+EventBlock.h"

@interface WOTTankListCompoundViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;

@end

@implementation WOTTankListCompoundViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = WOTApiTexts.groupAndSort;//WOTString(WOTApiTexts.groupAndSort);
    
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:WOTApiTexts.image_back/*WOTString()*/] text:nil eventBlock:^(id sender) {
        if (self.cancelBlock){
            self.cancelBlock();
        }
        
    }];
    [self.navigationItem setLeftBarButtonItems:@[backItem]];

    UIBarButtonItem *applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTApiTexts.apply/*WOTString()*/ eventBlock:^(id sender) {
        if (self.applyBlock){
            self.applyBlock();
        }
        
    }];
    [self.navigationItem setRightBarButtonItems:@[applyItem]];
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankListCompoundViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankListCompoundViewTableViewCell class])];

}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankListCompoundViewTableViewCell class]) forIndexPath:indexPath];
    return result;
}

#pragma mark - UITableViewDelegate
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

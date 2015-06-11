//
//  WOTTankListSettingViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingViewController.h"

@interface WOTTankListSettingViewController ()

@end

@implementation WOTTankListSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_CANCEL) eventBlock:^(id sender) {
        if (self.cancelBlock){
            self.cancelBlock();
        }
        
    }];
    [self.navigationItem setLeftBarButtonItems:@[backItem]];
    
    UIBarButtonItem *applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_EDIT) eventBlock:^(id sender) {
        if (self.applyBlock){
            self.applyBlock();
        }
        
    }];
    [self.navigationItem setRightBarButtonItems:@[applyItem]];
    [self.navigationController.navigationBar setDarkStyle];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

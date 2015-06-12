//
//  WOTTankListSettingViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingViewController.h"

@implementation WOTTankListSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_BACK)];
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
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
    
}

@end

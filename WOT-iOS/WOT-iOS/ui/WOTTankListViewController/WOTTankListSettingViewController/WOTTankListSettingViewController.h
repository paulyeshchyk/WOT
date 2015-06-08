//
//  WOTTankListSettingViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/8/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WOTTankListSettingCancelBlock) ();
typedef void (^WOTTankListSettingApplyBlock) ();


@interface WOTTankListSettingViewController : UIViewController

@property (nonatomic, copy) WOTTankListSettingCancelBlock cancelBlock;
@property (nonatomic, copy) WOTTankListSettingApplyBlock applyBlock;


@end

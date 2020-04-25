//
//  WOTTankListSortViewController.h
//  WOT-iOS
//
//  Created on 6/8/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WOTTankListCompoundCancelBlock) (void);
typedef void (^WOTTankListCompoundApplyBlock) (void);

@interface WOTTankListSortViewController : UIViewController

@property (nonatomic, copy) WOTTankListCompoundCancelBlock cancelBlock;
@property (nonatomic, copy) WOTTankListCompoundApplyBlock commitBlock;

@end

//
//  WOTTankGridViewController.h
//  WOT-iOS
//
//  Created on 9/14/15.
//  Copyright (c) 2015. All rights reserved.
//

@protocol WOTGridViewControllerDelegate <NSObject>

- (WOTPivotDataModel *)gridData;

@end

@interface WOTTankGridViewController : UIViewController

@property (nonatomic, assign)id<WOTGridViewControllerDelegate>delegate;

- (void)reload;
- (void)needToBeCleared;

@end

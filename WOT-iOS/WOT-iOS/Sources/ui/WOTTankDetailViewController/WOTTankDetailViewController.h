//
//  WOTTankDetailViewController.h
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOT-Swift.h>
#import <UIKit/UIKit.h>

@interface WOTTankDetailViewController : UIViewController<WOTViewControllerProtocol>

@property (nonatomic, strong) NSNumber *tankId;

@end
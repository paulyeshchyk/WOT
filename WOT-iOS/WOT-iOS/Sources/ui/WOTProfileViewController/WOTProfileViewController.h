//
//  WOTProfileViewController.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WOTViewControllerProtocol;
#pragma clang diagnostic push
// To get rid of 'No protocol definition found' warnings which are not accurate
#pragma clang diagnostic ignored "-Weverything"

@interface WOTProfileViewController : UIViewController<WOTViewControllerProtocol>

@end

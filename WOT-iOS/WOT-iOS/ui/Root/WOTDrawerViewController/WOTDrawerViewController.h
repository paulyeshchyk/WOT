//
//  WOTDrawerViewController.h
//  WOT-iOS
//
//  Created on 6/3/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>

@protocol WOTViewControllerProtocol;

@interface WOTDrawerViewController : MMDrawerController<WOTViewControllerProtocol>

- (id _Nonnull)initWithMenu;
+ (WOTDrawerViewController * _Nonnull)newDrawer;

@end

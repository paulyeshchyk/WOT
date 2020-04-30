//
//  WOTDrawerViewController.h
//  WOT-iOS
//
//  Created on 6/3/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOT-Swift.h>
#import <MMDrawerController/MMDrawerController.h>

@interface WOTDrawerViewController : MMDrawerController<WOTViewControllerProtocol>

- (id _Nonnull)initWithMenu;
+ (WOTDrawerViewController * _Nonnull)newDrawer;

@end

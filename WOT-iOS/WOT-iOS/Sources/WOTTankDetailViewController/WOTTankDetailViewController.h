//
//  WOTTankDetailViewController.h
//  WOT-iOS
//
//  Created on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <WOT-Swift.h>
#import <UIKit/UIKit.h>

@interface WOTTankDetailViewController : UIViewController<ContextControllerProtocol>

@property (nonatomic, strong) NSNumber *tankId;

- (id)initWithContext:(id<ContextProtocol>)context;

@end

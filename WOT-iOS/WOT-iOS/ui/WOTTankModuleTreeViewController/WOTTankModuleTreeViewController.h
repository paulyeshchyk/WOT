//
//  WOTTankModuleTreeViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WOTConfigurationCompletionCancelBlock) (void);
typedef void(^WOTConfigurationCompletionDoneBlock) (id configuration);

@interface WOTTankModuleTreeViewController : UIViewController

@property (nonatomic, copy)NSNumber *tank_Id;

@property (nonatomic, copy)WOTConfigurationCompletionCancelBlock cancelBlock;
@property (nonatomic, copy)WOTConfigurationCompletionDoneBlock doneBlock;

@end

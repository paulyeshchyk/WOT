//
//  WOTTankPivotViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WOTTankPivotCompletionCancelBlock) ();
typedef void(^WOTTankPivotCompletionDoneBlock) (id configuration);

@interface WOTTankPivotViewController : UIViewController

@property (nonatomic, copy)WOTTankPivotCompletionCancelBlock cancelBlock;
@property (nonatomic, copy)WOTTankPivotCompletionDoneBlock doneBlock;

@end

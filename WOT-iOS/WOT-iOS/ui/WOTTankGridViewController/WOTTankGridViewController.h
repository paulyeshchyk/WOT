//
//  WOTTankGridViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

@protocol WOTGridViewControllerDelegate <NSObject>

- (id)gridData;

@end

@interface WOTTankGridViewController : UIViewController

@property (nonatomic, assign)id<WOTGridViewControllerDelegate>delegate;

- (void)reload;
- (void)needToBeCleared;

@end

//
//  WOTTankListSearchBar.h
//  WOT-iOS
//
//  Created by Paul on 7/27/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchCommitBlock)(NSString *text);
typedef void(^SearchCloseBlock)();

@interface WOTTankListSearchBar : UIView

@property (nonatomic, copy)SearchCommitBlock commitBlock;
@property (nonatomic, copy)SearchCloseBlock closeBlock;

@end
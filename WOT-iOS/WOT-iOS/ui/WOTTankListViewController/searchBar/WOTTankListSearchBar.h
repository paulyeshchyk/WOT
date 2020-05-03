//
//  WOTTankListSearchBar.h
//  WOT-iOS
//
//  Created on 7/27/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchCommitBlock)(NSString *text);
typedef void(^SearchCloseBlock)(void);

@interface WOTTankListSearchBar : UIView

@property (nonatomic, copy)SearchCommitBlock commitBlock;
@property (nonatomic, copy)SearchCloseBlock closeBlock;

@end

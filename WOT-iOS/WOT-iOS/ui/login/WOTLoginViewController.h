//
//  WOTLoginViewController.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSession.h"

typedef void(^WOTLoginCallback)(NSString *status, NSString *userID, NSString *access_token, NSString *account_id, NSNumber *expires_at);
typedef void(^WOTLogout)(void);


@interface WOTLoginViewController : UIViewController


@property (nonatomic, copy)WOTLoginCallback callback;

+ (UserSession *)currentSession;
+ (void)logoutWithCallback:(WOTLogout)callback;

@end

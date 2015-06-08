//
//  WOTSessionDataProvider.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOTSessionDataProvider : NSObject

+ (id)currentAccessToken;
+ (NSString *)currentUserName;

+ (void)switchUser;
+ (void)logout;
+ (void)login;
+ (BOOL)sessionHasBeenExpired;

+ (WOTSessionDataProvider *)sharedInstance;

- (void)invalidateTimer;

@end

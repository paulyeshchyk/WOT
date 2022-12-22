//
//  WOTSessionManager.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ContextSDK/ContextSDK.h>

typedef NSTimer*(^WOTSessionManagerInvalidateTimeCompletion)(NSTimeInterval interval);

@interface WOTSessionManager : NSObject

+ (id)currentAccessToken;
+ (NSString *)currentUserName;

+ (void)switchUserWithRequestManager:(id<RequestManagerProtocol>) requestManager;
+ (void)logoutWithRequestManager:(id<RequestManagerProtocol>) requestManager;
+ (void)loginWithRequestManager:(id<RequestManagerProtocol>) requestManager;
+ (BOOL)sessionHasBeenExpired;

+ (WOTSessionManager *)sharedInstance;

- (void)invalidateTimer:(WOTSessionManagerInvalidateTimeCompletion)completion;


@end

//
//  WOTSessionManager.h
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WOTPivot/WOTPivot-Swift.h>

typedef NSTimer*(^WOTSessionManagerInvalidateTimeCompletion)(NSTimeInterval interval);

@interface WOTSessionManager : NSObject

+ (id)currentAccessToken;
+ (NSString *)currentUserName;

+ (void)switchUserWithRequestManager:(id<WOTRequestManagerProtocol>) requestManager;
+ (void)logoutWithRequestManager:(id<WOTRequestManagerProtocol>) requestManager;
+ (void)loginWithRequestManager:(id<WOTRequestManagerProtocol>) requestManager;
+ (BOOL)sessionHasBeenExpired;

+ (WOTSessionManager *)sharedInstance;

- (void)invalidateTimer:(WOTSessionManagerInvalidateTimeCompletion)completion;


@end

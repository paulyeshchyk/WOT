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

+ (BOOL)sessionHasBeenExpired;

+ (WOTSessionManager *)sharedInstance;

- (void)invalidateTimer:(WOTSessionManagerInvalidateTimeCompletion)completion;


@end

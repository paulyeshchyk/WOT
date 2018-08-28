//
//  WOTSessionManager.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSessionManager.h"
#import <WOTPivot/WOTPivot.h>
#import <WOTData/WOTData.h>

@interface WOTSessionManager ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation WOTSessionManager

+ (id)currentAccessToken {

    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.access_token;
}

+ (NSString *)currentUserName {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.nickname;
}

+ (NSTimeInterval)expirationTime {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return [session.expires_at integerValue];
}

+ (void)logout {
    
    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdLogout];
    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_LOGOUT];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:nil];
    }
}

+ (void)login {

    WOTRequest *request = [[WOTRequestExecutor sharedInstance] createRequestForId:WOTRequestIdLogin];

    BOOL canAdd = [[WOTRequestExecutor sharedInstance] addRequest:request byGroupId:WOT_REQUEST_ID_LOGIN];
    if (canAdd) {
        
        [[WOTRequestExecutor sharedInstance] runRequest:request withArgs:nil];
    }
}

+ (void)switchUser {
    
    id access_token = [self currentAccessToken];
    if (access_token){

        [self logout];
    } else {
        

        [self login];
    }
}

+ (BOOL)sessionHasBeenExpired {
    
    NSTimeInterval expirationAt = [self expirationTime];
    NSTimeInterval timeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
    return expirationAt <= timeIntervalSince1970;
}

+ (WOTSessionManager *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        [NSThread executeOnMainThread:^{
            
            instance = [[self alloc] init];
        }];
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        

    }
    return self;
}

- (void)invalidateTimer:(WOTSessionManagerInvalidateTimeCompletion) completion {
 
    [self.timer invalidate];
    [self updateTimer:completion];
    
}

#pragma mark - private
- (void)updateTimer:(WOTSessionManagerInvalidateTimeCompletion)completion {
    
    if ([WOTSessionManager sessionHasBeenExpired]) {
        
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    NSTimeInterval expirationTime = [WOTSessionManager expirationTime];
    NSTimeInterval interval = expirationTime - [[NSDate date] timeIntervalSince1970];
    self.timer = completion(interval);

}

@end

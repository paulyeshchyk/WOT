//
//  WOTSessionDataProvider.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSessionDataProvider.h"
#import "WOTCoreDataProvider.h"
#import "UserSession.h"
#import "WOTRequestExecutor+Registration.h"
#import "NSTimer+BlocksKit.h"

@interface WOTSessionDataProvider ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation WOTSessionDataProvider

+ (id)currentAccessToken {

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.access_token;
}

+ (NSString *)currentUserName {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.nickname;
}

+ (NSTimeInterval)expirationTime {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return [session.expires_at integerValue];
}

+ (void)logout {
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdLogout args:nil];
}

+ (void)login {

    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestIdLogin args:nil];
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



+ (WOTSessionDataProvider *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        if ([NSThread isMainThread]) {
            instance = [[self alloc] init];
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                instance = [[self alloc] init];
            });
        }
        
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        

    }
    return self;
}

- (void)invalidateTimer {
 
    [self.timer invalidate];
    [self updateTimer];
    
}

#pragma mark - private
- (void)updateTimer {
    
    if ([WOTSessionDataProvider sessionHasBeenExpired]) {
        
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    NSTimeInterval expirationTime = [WOTSessionDataProvider expirationTime];
    NSTimeInterval interval = expirationTime - [[NSDate date] timeIntervalSince1970];

    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:interval block:^(NSTimer *timer) {
        
        [WOTSessionDataProvider logout];
    } repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}

@end

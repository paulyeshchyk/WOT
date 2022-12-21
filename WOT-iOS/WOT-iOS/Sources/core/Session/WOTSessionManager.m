//
//  WOTSessionManager.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTSessionManager.h"
#import <WOTApi/WOTApi.h>

#import "WOTRequestIds.h"
#import "NSThread+ExecutionOnMain.h"

@interface WOTSessionManager ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation WOTSessionManager

+ (void)loginWithRequestManager:(id<RequestManagerProtocol>) requestManager {
    
}

+ (void)switchUserWithRequestManager:(id<RequestManagerProtocol>) requestManager {
    
}

+ (id)currentAccessToken {
    return nil;
//    id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
//    id<WOTCoredataStoreProtocol> coreDataProvider = appDelegate.appManager.coreDataStore;
//    NSManagedObjectContext *context = [coreDataProvider mainContext];
//    UserSession *session = (UserSession *)[context singleObjectForType:UserSession.class predicate:nil includeSubentities:NO];
//    return session.access_token;
}

+ (NSString *)currentUserName {
    return nil;
//    id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
//    id<WOTCoredataStoreProtocol> coreDataProvider = appDelegate.appManager.coreDataStore;
//    NSManagedObjectContext *context = [coreDataProvider mainContext];
//    UserSession *session = (UserSession *)[context singleObjectForType:UserSession.class predicate:nil includeSubentities:NO];
//    return session.nickname;
}

+ (NSTimeInterval)expirationTime {
    return [NSDate timeIntervalSinceReferenceDate];
//    id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
//    id<WOTCoredataStoreProtocol> coreDataProvider = appDelegate.appManager.coreDataStore;
//    NSManagedObjectContext *context = [coreDataProvider mainContext];
//    UserSession *session = (UserSession *)[context singleObjectForType:UserSession.class predicate:nil includeSubentities:NO];
//    return [session.expires_at integerValue];
}


+ (void)logoutWithRequestManager:(id<RequestManagerProtocol>) requestManager {
//    id<WOTRequestProtocol> request = [requestManager.requestCoordinator createRequestForRequestId:WOTRequestIdLogout];
//    [requestManager start:request with:[[WOTRequestArguments alloc] init] forGroupId:WGWebRequestGroups.logout jsonLink: NULL];
}

//+ (void)loginWithRequestManager:(id<RequestManagerProtocol>) requestManager {

//    id<WOTRequestProtocol> request =  [requestManager.requestCoordinator createRequestForRequestId:WOTRequestIdLogout];
//
//    NSString *host = requestManager.hostConfiguration.host;
//    NSString *noFollow = @"1";
//    NSString *redirectUri = [NSString stringWithFormat:@"%@/developers/api_explorer/wot/auth/login/complete/", host];
//    WOTRequestArguments *args = [[WOTRequestArguments alloc] init];
//    [args setValues:@[noFollow] forKey: WOTApiKeys.nofollow];
//    [args setValues:@[redirectUri] forKey: WOTApiKeys.redirectUri];
//
//    [requestManager start:request with:args forGroupId:WGWebRequestGroups.login jsonLink: NULL];
//}

//+ (void)switchUserWithRequestManager:(id<RequestManagerProtocol>)requestManager {
//    
//    id access_token = [self currentAccessToken];
//    if (access_token){
//        [self logoutWithRequestManager:requestManager];
//    } else {
//        [self loginWithRequestManager:requestManager];
//    }
//}

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

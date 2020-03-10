//
//  WOTSessionManager.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTSessionManager.h"

#import <WOTData/WOTData.h>

//#import "UserSession+CoreDataClass.h"
#import <WOTData/WOTData-Swift.h>

@interface WOTSessionManager ()

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation WOTSessionManager

+ (id)currentAccessToken {

    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = (UserSession *)[UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includeSubentities:NO];
    return session.access_token;
}

+ (NSString *)currentUserName {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = (UserSession *)[UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includeSubentities:NO];
    return session.nickname;
}

+ (NSTimeInterval)expirationTime {
    
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    UserSession *session = (UserSession *)[UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includeSubentities:NO];
    return [session.expires_at integerValue];
}

+ (void)logout {
    id<WOTHostConfigurationOwner> hostOwner = (id<WOTHostConfigurationOwner>) [UIApplication sharedApplication].delegate;
    
    id<WOTRequestProtocol> request = [[WOTRequestReception sharedInstance] createRequestForRequestId:WOTRequestIdLogout];
    request.hostConfiguration = hostOwner.hostConfiguration;
    BOOL canAdd = [[WOTRequestExecutorSwift sharedInstance] addRequest:request forGroupId:WGWebRequestGroups.logout];
    if (canAdd) {
        [request start:nil];
    }
}

+ (void)login {

    id<WOTHostConfigurationOwner> hostOwner = (id<WOTHostConfigurationOwner>) [UIApplication sharedApplication].delegate;
    id<WOTHostConfigurationProtocol> hostConfiguration = hostOwner.hostConfiguration;

    id<WOTRequestProtocol> request =  [[WOTRequestReception sharedInstance] createRequestForRequestId:WOTRequestIdLogout];
    request.hostConfiguration = hostConfiguration;
    BOOL canAdd = [[WOTRequestExecutorSwift sharedInstance] addRequest:request forGroupId:WGWebRequestGroups.login];
    if (canAdd) {
        
        NSString *appId = hostOwner.hostConfiguration.applicationID;
        NSString *noFollow = @"1";
        NSString *redirectUri = [NSString stringWithFormat:@"%@/developers/api_explorer/wot/auth/login/complete/",hostConfiguration.host];
        WOTRequestArguments *args = [[WOTRequestArguments alloc] init];
        [args setValues:@[noFollow] forKey: WOTApiKeys.nofollow];
        [args setValues:@[redirectUri] forKey: WOTApiKeys.redirectUri];
        [request start:args];
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

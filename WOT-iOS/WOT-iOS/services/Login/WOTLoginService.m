//
//  WOTLoginService.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLoginService.h"
#import "WOTConstants.h"
#import "WOTError.h"
#import "WOTErrorCodes.h"

@interface WOTLoginService ()

- (void)start;

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *redirectPath;
@property (nonatomic, copy) LoginCallback callback;

@end

@implementation WOTLoginService


+ (void)loginWithAppID:(NSString *)appID redirectPath:(NSString *)redirectPath callback:(LoginCallback)callback {
    
    WOTLoginService *service = [[self alloc] init];
    service.appID = appID;
    service.callback = callback;
    service.redirectPath = redirectPath;
    [service start];
    
}

+ (void)logoutWithAppID:(NSString *)appID accessToken:(NSString *)access_token callback:(LogoutCallback)callback {
    
    if (!access_token) {
        
        if (callback) {
            
            callback([WOTError loginErrorWithCode:WOT_ERROR_CODE_ACCESS_TOKEN_NOT_DEFINED userInfo:nil]);
        }
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.worldoftanks.ru/wot/auth/logout/"]];
    [request setHTTPMethod:@"POST"];
    
    NSError *serializatoinError;
    NSData *httpBodyData = [NSJSONSerialization dataWithJSONObject:@{@"application_id":appID,@"access_token":access_token}
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&serializatoinError];
    [request setHTTPBody:httpBodyData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[WOTLoginService requestQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_sync(dispatch_get_main_queue(), ^{
    
            [WOTLoginService clearCookiesForURL:[NSURL URLWithString:@"https://api.worldoftanks.ru"]];
            [WOTLoginService clearCache];
            
            if (callback) {
                
                callback(connectionError);
            }
        });
    }];
}

+ (NSOperationQueue *)requestQueue {
//#warning Should we cancel previous request when session changed?
    static NSOperationQueue *_requestQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestQueue = [NSOperationQueue new];
    });
    
    return _requestQueue;
}

+ (void)clearCookiesForURL:(NSURL *)url {
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}

+ (void)clearCache {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)start {
    
    NSString *requestPath = [NSString stringWithFormat:@"https://api.worldoftanks.ru/wot/auth/login/?application_id=%@&nofollow=1&redirect_uri=%@",self.appID,self.redirectPath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestPath]];

    [NSURLConnection sendAsynchronousRequest:request queue:[WOTLoginService requestQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        id location = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL][@"data"][@"location"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (self.callback) {
                
                self.callback(location);
            }
        });
    }];
}

@end

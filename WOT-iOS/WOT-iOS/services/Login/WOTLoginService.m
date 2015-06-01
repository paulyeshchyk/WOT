//
//  WOTLoginService.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLoginService.h"
#import "WOTConstants.h"

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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.worldoftanks.ru/wot/auth/logout/"]];
    [request setHTTPMethod:@"POST"];
    
    NSError *serializatoinError;
    NSData *httpBodyData = [NSJSONSerialization dataWithJSONObject:@{@"application_id":appID,@"access_token":access_token}
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&serializatoinError];
    [request setHTTPBody:httpBodyData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[WOTLoginService requestQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (callback) {
            callback();
        }
    
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


- (void)start {
    
    NSString *requestPath = [NSString stringWithFormat:@"https://api.worldoftanks.ru/wot/auth/login/?application_id=%@&nofollow=1&redirect_uri=%@",self.appID,self.redirectPath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestPath]];

    [NSURLConnection sendAsynchronousRequest:request queue:[WOTLoginService requestQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        id location = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL][@"data"][@"location"];
        if (self.callback) {
            
            self.callback(location);
        }
    }];
}

@end

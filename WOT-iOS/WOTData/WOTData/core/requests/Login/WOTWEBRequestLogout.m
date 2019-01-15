//
//  WOTWEBRequestLogout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestLogout.h"
#import <WOTPivot/WOTPivot.h>
#import "WOTDataDefines.h"
#import "WOTSessionManager.h"

@implementation WOTWEBRequestLogout

+ (void)clearCookies {
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        debugLog(@"Deleting cookie for domain: %@", [cookie domain]);
        [cookieStorage deleteCookie:cookie];
    }
}

+ (void)clearCache {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (NSString *)method {
    
    return @"POST";
}

- (NSString *)path {
    
    return @"wot/auth/logout/";
}

- (NSDictionary *)query {
    
    return @{WOTApiKeys.applicationId:[NSString valueOrSpaceString:self.hostConfiguration.applicationID], WOTApiKeys.accessToken:[NSString valueOrSpaceString:self.access_token]};
}

- (NSData *)httpBodyData {
    
    NSString * query = [self queryIntoString];
    NSData *result = [query dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (void)temp_executeWithArgs:(WOTRequestArguments *)args{
    
    [super temp_executeWithArgs:args];

    [WOTWEBRequestLogout clearCache];
    [WOTWEBRequestLogout clearCookies];

}

- (NSString *)access_token {
    
    return [WOTSessionManager currentAccessToken];
}



@end

//
//  WOTWEBRequestLogin.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTWEBRequestLogin.h"
#import "WOTDataDefines.h"
#import <WOTData/WOTData-Swift.h>

@implementation WOTWEBRequestLogin

- (NSString *)method {
    
    return @"POST";
}

- (NSString *)path {
    
    return @"wot/auth/login/";
}

- (NSDictionary *)query {

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOTApiKeys.queryArgApplicationID] = [NSString valueOrSpaceString:self.applicationID];
    result[WOTApiKeys.nofollow] = [NSString valueOrSpaceString:self.noFollow];
    result[WOTApiKeys.redirectUri] = [NSString valueOrSpaceString:self.redirectURL];
    return result;
}

- (NSString *)applicationID {
    
    return WOT_VALUE_APPLICATION_ID_RU;
}

- (NSString *)redirectURL {
    
    return [NSString stringWithFormat:@"%@/developers/api_explorer/wot/auth/login/complete/",self.hostConfiguration.host];
}

- (NSString *)noFollow {
    
    return @"1";
}

- (NSDictionary *)userInfo {
    
    return @{WOTApiKeys.redirectUri:self.redirectURL};
}

- (NSData *)httpBodyData {
    
    NSString * query = [self queryIntoString];
    NSData *result = [query dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
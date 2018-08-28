//
//  WOTWEBRequestLogin.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestLogin.h"

@implementation WOTWEBRequestLogin

- (NSString *)method {
    
    return @"POST";
}

- (NSString *)path {
    
    return @"wot/auth/login/";
}

- (NSDictionary *)query {
    

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[WOT_KEY_APPLICATION_ID] = [NSString valueOrSpaceString:self.applicationID];
    result[WOT_KEY_NOFOLLOW] = [NSString valueOrSpaceString:self.noFollow];
    result[WOT_KEY_REDIRECT_URI] = [NSString valueOrSpaceString:self.redirectURL];
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
    
    return @{WOT_KEY_REDIRECT_URI:self.redirectURL};
}

- (NSData *)httpBodyData {
    
    NSString * query = [self queryIntoString];
    NSData *result = [query dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end

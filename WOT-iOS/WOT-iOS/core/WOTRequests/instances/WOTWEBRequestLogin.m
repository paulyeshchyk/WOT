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
    result[@WOT_APPLICATION_ID] = [NSString valueOrSpaceString:self.applicationID];
    result[@WOT_NOFOLLOW] = [NSString valueOrSpaceString:self.noFollow];
    result[@WOT_REDIRECT_URI] = [NSString valueOrSpaceString:self.redirectURL];
    return result;
}

- (NSString *)applicationID {
    
    return @"e3a1e0889ff9c76fa503177f351b853c";
}

- (NSString *)redirectURL {
    
    return [NSString stringWithFormat:@"%@/developers/api_explorer/wot/auth/login/complete/",self.host];
}

- (NSString *)noFollow {
    
    return @"1";
}

- (NSDictionary *)userInfo {
    
    return @{@WOT_REDIRECT_URI:self.redirectURL};
}

- (NSData *)httpBodyData {
    
    NSString * query = [self queryIntoString];
    NSData *result = [query dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end

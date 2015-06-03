//
//  WOTWEBRequestLogout.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/3/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTWEBRequestLogout.h"
#import "UserSession.h"

@implementation WOTWEBRequestLogout

+ (void)clearCookies {
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Deleting cookie for domain: %@", [cookie domain]);
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
    
    return @{@WOT_APPLICATION_ID:[NSString valueOrSpaceString:self.applicationID], @WOT_ACCESS_TOKEN:[NSString valueOrSpaceString:self.access_token]};
}

- (NSString *)applicationID {
    
    return @"e3a1e0889ff9c76fa503177f351b853c";
}

- (NSString *)access_token {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.access_token;
}

- (NSData *)httpBodyData {
    
    NSString * query = [self queryIntoString];
    NSData *result = [query dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (void)executeWithArgs:(NSDictionary *)args {

    [WOTWEBRequestLogout clearCache];
    [WOTWEBRequestLogout clearCookies];

    [super executeWithArgs:args];
}

@end

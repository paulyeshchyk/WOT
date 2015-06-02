//
//  WOTLoginService.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginCallback)(NSString *redirectURLPath);
typedef void(^LogoutCallback)(NSError *error);

@interface WOTLoginService : NSObject

+ (void)loginWithAppID:(NSString *)appID redirectPath:(NSString *)redirectPath callback:(LoginCallback)callback;

+ (void)logoutWithAppID:(NSString *)appID accessToken:(NSString *)access_token callback:(LogoutCallback)callback ;

@end

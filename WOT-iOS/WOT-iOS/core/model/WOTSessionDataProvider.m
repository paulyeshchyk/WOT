//
//  WOTSessionDataProvider.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSessionDataProvider.h"
#import "WOTCoreDataProvider.h"
#import "UserSession.h"
#import "WOTRequestExecutor+Registration.h"

@implementation WOTSessionDataProvider

+ (id)currentAccessToken {

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.access_token;
}

+ (NSString *)currentUserName {
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession singleObjectWithPredicate:nil inManagedObjectContext:context includingSubentities:NO];
    return session.nickname;
}

+ (void)logout {
    
    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLogoutId args:nil];
}

+ (void)login {

    [[WOTRequestExecutor sharedInstance] executeRequestById:WOTRequestLoginId args:nil];
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
    
    return YES;
}

@end

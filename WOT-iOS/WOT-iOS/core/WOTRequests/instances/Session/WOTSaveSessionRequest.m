//
//  WOTSaveSessionRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSaveSessionRequest.h"
#import "UserSession.h"
#import "WOTCoreDataProvider.h"

@implementation WOTSaveSessionRequest

- (void)executeWithArgs:(NSDictionary *)args {

    [super executeWithArgs:args];

    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] mainManagedObjectContext];
    UserSession *session = [UserSession insertNewObjectInManagedObjectContext:context];
    session.nickname = args[WOT_KEY_USER_ID];
    session.access_token = args[WOT_KEY_ACCESS_TOKEN];
    session.accound_id = args[WOT_KEY_ACCOUNT_ID];
    session.expires_at = args[WOT_KEY_EXPIRES_AT];
    NSError *error = nil;
    [context save:&error];

    if (self.callback) {
        
        self.callback(nil, error);
    }
    
}

@end

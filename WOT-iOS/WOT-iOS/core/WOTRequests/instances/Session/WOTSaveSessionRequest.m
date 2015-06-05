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
    NSDate *date = [NSDate date];
    
    
    NSManagedObjectContext *context = [[WOTCoreDataProvider sharedInstance] managedObjectContext];
    UserSession *session = [UserSession insertNewObjectInManagedObjectContext:context];
    session.nickname = args[WOT_KEY_USER_ID];
    session.access_token = args[WOT_KEY_ACCESS_TOKEN];
    session.accound_id = args[WOT_KEY_ACCOUNT_ID];
    session.expires_at = @([date timeIntervalSince1970]+60 * 2);//args[WOT_KEY_EXPIRES_AT];
    NSError *error = nil;
    [context save:&error];

    if (error) {

        if (self.errorCallback) {
            
            self.errorCallback(error);
        }
    } else {
        
        if (self.jsonCallback) {
            
            self.jsonCallback(nil);
        }
    }
    
}

@end

//
//  WOTSaveSessionRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSaveSessionRequest.h"
#import <WOTData/WOTData.h>

@implementation WOTSaveSessionRequest

- (void)temp_executeWithArgs:(NSDictionary *)args{

    [super temp_executeWithArgs:args];

    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    [context performBlock:^{
        
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
    }];
    
}

@end

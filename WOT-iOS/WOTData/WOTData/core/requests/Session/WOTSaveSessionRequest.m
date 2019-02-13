//
//  WOTSaveSessionRequest.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/2/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTSaveSessionRequest.h"
#import <WOTData/WOTData.h>
#import "NSManagedObject+CoreDataOperations.h"

@implementation WOTSaveSessionRequest

- (void)temp_executeWithArgs:(WOTRequestArguments *)args{

    [super temp_executeWithArgs:args];

    NSDictionary *fields = args.asDictionary;
    id<WOTCoredataProviderProtocol> dataProvider = [WOTCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    [context performBlock:^{

        UserSession *session = [UserSession insertNewObjectInManagedObjectContext:context];
        session.nickname = fields[WOT_KEY_USER_ID];
        session.access_token = fields[WOTApiKeys.accessToken];
        session.accound_id = fields[WOT_KEY_ACCOUNT_ID];
        session.expires_at = fields[WOT_KEY_EXPIRES_AT];
        NSError *error = nil;
        [context save:&error];
        
        if (self.callback) {
            
            self.callback(nil, error);
        }
    }];
    
}

@end

//
//  WOTSaveSessionRequest.m
//  WOT-iOS
//
//  Created on 6/2/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTSaveSessionRequest.h"
#import <WOTData/WOTData.h>
#import <WOTData/WOTData-Swift.h>

@implementation WOTSaveSessionRequest
+ (NSString *)instanceClassName {
    return @"";
}


- (void)start:(WOTRequestArguments * _Nonnull)args{

    [super start:args];

    NSDictionary *fields = args.asDictionary;
    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    [context performBlock:^{

        UserSession *session = (UserSession *)[UserSession insertNewObject:context];
        session.nickname = fields[WOT_KEY_USER_ID];
        session.access_token = fields[WOTApiKeys.accessToken];
        session.accound_id = fields[WOT_KEY_ACCOUNT_ID];
        session.expires_at = fields[WOT_KEY_EXPIRES_AT];
        NSError *error = nil;
        [context save:&error];
        
        if (self.callback) {
            
            self.callback(nil, error, nil);
        }
    }];
    
}

@end

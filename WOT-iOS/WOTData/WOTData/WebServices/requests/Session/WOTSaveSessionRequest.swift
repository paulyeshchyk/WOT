//
//  WOTSaveSessionRequest.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTSaveSessionRequest : WOTWEBRequest {
    @objc
    public class func modelClassName() -> String {
        return ""
    }

    //- (void)start:(WOTRequestArguments * _Nonnull)args{
    //
    //    //[super start:args];
    //
    //    NSDictionary *fields = args.dictionary;
    //    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    //    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    //    [context performBlock:^{
    //
    //        UserSession *session = (UserSession *)[UserSession insertNewObject:context];
    //        session.nickname = fields[WOT_KEY_USER_ID];
    //        session.access_token = fields[WOTApiKeys.accessToken];
    //        session.accound_id = fields[WOT_KEY_ACCOUNT_ID];
    //        session.expires_at = fields[WOT_KEY_EXPIRES_AT];
    //        NSError *error = nil;
    //        [context save:&error];
    //
    //        if (self.callback) {
    //
    //            self.callback(nil, error, nil);
    //        }
    //    }];
    //
    //}
}

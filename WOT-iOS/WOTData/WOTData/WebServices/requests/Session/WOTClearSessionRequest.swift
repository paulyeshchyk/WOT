//
//  WOTClearSessionRequest.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTClearSessionRequest : WOTWEBRequest {
    override public var method: String { return "POST" }

    @objc
    public class func modelClassName() -> String {
        return ""
    }

    //- (void)start:(WOTRequestArguments * _Nonnull)args {
    //
    //    [super start:args];
    //
    //    id<WOTCoredataProviderProtocol> dataProvider = [WOTTankCoreDataProvider sharedInstance];
    //    NSManagedObjectContext *context = [dataProvider mainManagedObjectContext];
    //    [context performBlock:^{
    //
    //        [UserSession removeObjectsByPredicate:nil inManagedObjectContext:context];
    //
    //        NSError *error = nil;
    //        [context save:&error];
    //
    //        if (self.callback) {
    //
    //            self.callback(nil, error, nil);
    //        }
    //    }];
    //}
}

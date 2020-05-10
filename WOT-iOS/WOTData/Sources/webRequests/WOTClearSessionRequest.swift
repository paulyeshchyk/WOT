//
//  WOTClearSessionRequest.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

@objc
public class WOTClearSessionRequest: WOTWEBRequest, WOTModelServiceProtocol {
    override public var method: HTTPMethods { return .POST }

    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    public func instanceModelClass() -> AnyClass? {
        return nil
    }

    @objc
    public class func modelClassName() -> String {
        return ""
    }

    // - (void)start:(WOTRequestArguments * _Nonnull)args {
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
    // }
}

//
//  WOTWEBRequestTanks.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTanks: WOTWEBRequest {
    
    override public var query: [AnyHashable : Any]! {
        return [WOTApiKeys.queryArgApplicationID: self.hostConfiguration.applicationID,
                WOTApiKeys.queryArgFields:self.args.escapedValue(forKey: WOTApiKeys.queryArgFields)]
    }
    
    override public var path: String! {
        return "/wot/encyclopedia/tanks/"
    }
}

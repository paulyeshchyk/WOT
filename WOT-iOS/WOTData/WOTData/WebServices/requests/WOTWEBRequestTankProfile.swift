//
//  WOTWEBRequestTankProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankProfile: WOTWEBRequest {
    
    override public var query: [AnyHashable : Any]! {
        return [WOTApiKeys.queryArgApplicationID: self.hostConfiguration.applicationID,
                WOTApiKeys.queryArgFields: self.args.escapedValue(forKey: WOTApiKeys.queryArgFields),
                WOTApiKeys.tank_id: self.args.escapedValue(forKey: WOTApiKeys.tank_id)]
    }

    override public var path: String! {
        return "/wot/encyclopedia/vehicleprofile/"
    }

    override public var method: String! {
        return "POST"
    }

}

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
    
    public class func instanceClassName() -> String!  {
        return NSStringFromClass(Vehicleprofile.self)
    }

    override public var query: [AnyHashable : Any]! {
        let fields = self.args?.escapedValue(forKey: WGWebQueryArgs.fields) ?? ""
        let tank_id = self.args?.escapedValue(forKey: WGWebQueryArgs.tank_id) ?? ""
        return [WGWebQueryArgs.application_id: self.hostConfiguration.applicationID,
                WGWebQueryArgs.fields: fields,
                WGWebQueryArgs.tank_id: tank_id]
    }

    override public var path: String! {
        return "/wot/encyclopedia/vehicleprofile/"
    }

    override public var method: String! {
        return "POST"
    }

}

//
//  WOTWEBRequestTankVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankVehicles: WOTWEBRequest, WOTModelServiceProtocol {

    override public var method: String { return "POST" }

    @available(*, deprecated, message: "TO be refactored")
    @objc
    public class func modelClassName() -> String {
        return NSStringFromClass(Vehicles.self)
    }

    @available(*, deprecated, message: "TO be refactored")
    @objc
    public func instanceModelClass() -> AnyClass? {
        return NSClassFromString( type(of: self).modelClassName() )
    }

//    override public var query: [AnyHashable : Any] {
////        let fields = self.args?.escapedValue(forKey: WGWebQueryArgs.fields) ?? ""
//        let fields = ""
//        return [WGWebQueryArgs.application_id: self.hostConfiguration.applicationID,
//                WGWebQueryArgs.fields: fields]
//    }
    
    override public var path: String {
        return "/wot/encyclopedia/vehicles/"
    }
}

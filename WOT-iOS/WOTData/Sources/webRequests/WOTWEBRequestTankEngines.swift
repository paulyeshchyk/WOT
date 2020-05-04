//
//  WOTWEBRequestTankEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

@objc
public class WOTWEBRequestTankEngines: WOTWEBRequest {
    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
}

extension WOTWEBRequestTankEngines: WOTModelServiceProtocol {
    @objc
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileEngine.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

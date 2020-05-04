//
//  WOTWEBRequestTankGuns.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

@objc
public class WOTWEBRequestTankGuns: WOTWEBRequest {
    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
}

extension WOTWEBRequestTankGuns: WOTModelServiceProtocol {
    @objc
    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileGun.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

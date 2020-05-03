//
//  WOTWEBRequestSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestSuspension: WOTWEBRequest {
    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
}

extension WOTWEBRequestSuspension: WOTModelServiceProtocol {
    @objc
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileSuspension.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

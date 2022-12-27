//
//  WOTWebRequestTankRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class VehicleprofileRadiosHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
}

extension VehicleprofileRadiosHttpRequest: ModelServiceProtocol {

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileRadio.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.radios.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

//
//  WOTWebRequestTankTurrets.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class VehicleprofileTurretsHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }

    override public var responseParserClass: ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    override public var dataAdapterClass: ResponseAdapterProtocol.Type {
        WGResponseJSONAdapter.self
    }
}

extension VehicleprofileTurretsHttpRequest: ModelServiceProtocol {
    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileTurret.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.turrets.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

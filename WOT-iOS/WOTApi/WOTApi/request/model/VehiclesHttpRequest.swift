//
//  WOTWEBRequestTankVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class VehiclesHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicles/"
    }
}

extension VehiclesHttpRequest: ModelServiceProtocol {

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return Vehicles.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.vehicles.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

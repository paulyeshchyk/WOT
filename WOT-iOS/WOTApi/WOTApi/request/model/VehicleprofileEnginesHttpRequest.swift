//
//  WOTWEBRequestTankEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class VehicleprofileEnginesHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
    
    override public var responseParserClass: ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    override public var dataAdapterClass: ResponseAdapterProtocol.Type {
        JSONAdapter.self
    }
}

extension VehicleprofileEnginesHttpRequest: ModelServiceProtocol {

    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileEngine.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.engines.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

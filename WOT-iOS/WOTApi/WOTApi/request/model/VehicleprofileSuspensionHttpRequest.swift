//
//  WOTWEBRequestSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class VehicleprofileSuspensionHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }

    override public var responseParserClass: ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    override public var dataAdapterClass: ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }
}

extension VehicleprofileSuspensionHttpRequest: ModelServiceProtocol {
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return VehicleprofileSuspension.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.suspension.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}

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
}

extension VehicleprofileSuspensionHttpRequest: ModelServiceProtocol {
    public class func responseParserClass() -> ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        VehicleprofileSuspension.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.suspension.rawValue
    }
}

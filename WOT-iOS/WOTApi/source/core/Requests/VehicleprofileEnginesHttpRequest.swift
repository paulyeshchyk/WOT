//
//  WOTWEBRequestTankEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileEnginesHttpRequest

public class VehicleprofileEnginesHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicleprofile/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
    override public func httpAPIQueryPrefix() -> String? { "engine." }
}

// MARK: - VehicleprofileEnginesHttpRequest + RequestModelServiceProtocol

extension VehicleprofileEnginesHttpRequest: RequestModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        VehicleprofileEngine.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.engines.rawValue
    }
}

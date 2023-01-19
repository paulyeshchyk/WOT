//
//  WOTWEBRequestTankVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehiclesHttpRequest

public class VehiclesHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicles/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
}

// MARK: - VehiclesHttpRequest + RequestModelServiceProtocol

extension VehiclesHttpRequest: RequestModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> ModelClassType? {
        Vehicles.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.vehicles.rawValue
    }
}

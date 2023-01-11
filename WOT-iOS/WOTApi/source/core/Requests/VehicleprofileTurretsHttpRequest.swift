//
//  WOTWebRequestTankTurrets.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - VehicleprofileTurretsHttpRequest

public class VehicleprofileTurretsHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicleprofile/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
    override public func httpAPIQueryPrefix() -> String? { "turret." }
}

// MARK: - VehicleprofileTurretsHttpRequest + ModelServiceProtocol

extension VehicleprofileTurretsHttpRequest: ModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        VehicleprofileTurret.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.turrets.rawValue
    }
}

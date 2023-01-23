//
//  WOTWebRequestTankTurrets.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileTurretsHttpRequest

public class VehicleprofileTurretsHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicleprofile/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
    override public func httpAPIQueryPrefix() -> String? { "turret." }
}

// MARK: - VehicleprofileTurretsHttpRequest + RequestModelServiceProtocol

extension VehicleprofileTurretsHttpRequest: RequestModelServiceProtocol {
    public class func responseDataDecoderClass() -> ResponseDataDecoderProtocol.Type {
        WGApiJSONDataDecoder.self
    }

    public class func modelClass() -> ModelClassType? {
        VehicleprofileTurret.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.turrets.rawValue
    }
}

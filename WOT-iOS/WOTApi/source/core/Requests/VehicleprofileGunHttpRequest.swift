//
//  WOTWEBRequestTankGuns.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileGunHttpRequest

public class VehicleprofileGunHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicleprofile/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
    override public func httpAPIQueryPrefix() -> String? { "gun." }
}

// MARK: - VehicleprofileGunHttpRequest + RequestModelServiceProtocol

extension VehicleprofileGunHttpRequest: RequestModelServiceProtocol {
    public class func responseDataDecoderClass() -> ResponseDataDecoderProtocol.Type {
        WGApiJSONDataDecoder.self
    }

    public class func modelClass() -> ModelClassType? {
        VehicleprofileGun.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.guns.rawValue
    }
}

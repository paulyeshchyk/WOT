//
//  WOTWebRequestTankRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileRadiosHttpRequest

public class VehicleprofileRadiosHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicleprofile/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
    override public func httpAPIQueryPrefix() -> String? { "radio." }
}

// MARK: - VehicleprofileRadiosHttpRequest + RequestModelServiceProtocol

extension VehicleprofileRadiosHttpRequest: RequestModelServiceProtocol {
    public class func responseDataDecoderClass() -> ResponseDataDecoderProtocol.Type {
        WGApiJSONDataDecoder.self
    }

    public class func modelClass() -> ModelClassType? {
        VehicleprofileRadio.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.radios.rawValue
    }
}

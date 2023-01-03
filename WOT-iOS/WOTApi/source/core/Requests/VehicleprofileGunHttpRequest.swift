//
//  WOTWEBRequestTankGuns.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - VehicleprofileGunHttpRequest

public class VehicleprofileGunHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }
}

// MARK: - VehicleprofileGunHttpRequest + ModelServiceProtocol

extension VehicleprofileGunHttpRequest: ModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        VehicleprofileGun.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.guns.rawValue
    }
}

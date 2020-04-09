//
//  WOTVehicleModuleType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum WOTVehicleModuleType: Int {
    case unknown
    case chassis
    case engine
    case radio
    case turret
    case gun

    var stringValue: String {
        switch self {
        case .unknown: return "unknown"
        case .chassis: return "vehicleChassis"
        case .turret: return "vehicleTurret"
        case .engine: return "vehicleEngine"
        case .gun: return "vehicleGun"
        case .radio: return "vehicleRadio"
        }
    }

    static func fromString(stringValue: String) -> WOTVehicleModuleType {
        switch stringValue.lowercased() {
        case "unknown": return .unknown
        case "vehicleChassis": return .chassis
        case "vehicleEngine": return .engine
        case "vehicleRadio": return .radio
        case "vehicleTurret": return .turret
        case "vehicleGun": return .gun
            #warning("WTF")
        default: return .unknown
        }
    }
}

@objc
public class WOTVehicleModuleTypeeOBJcConverter: NSObject {
    @objc
    public static func fromString(_ string: String) -> WOTVehicleModuleType {
        return WOTVehicleModuleType.fromString(stringValue: string)
    }
}

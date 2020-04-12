//
//  WOTVehicleModuleType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum VehicleModuleType: String {
    case unknown
    case vehicleChassis
    case vehicleEngine
    case vehicleRadio
    case vehicleTurret
    case vehicleGun
    case tank

    private static var allTypes: [VehicleModuleType] = [.unknown, .vehicleChassis, .vehicleEngine, .vehicleRadio, .vehicleTurret, .vehicleGun, .tank]

    var index: Int {
        guard let result = VehicleModuleType.allTypes.index(of: self) else { fatalError("VehicleModuleType.alltypes has no value:\(self)")}
        return result
    }

    static func value(for intValue: Int) -> VehicleModuleType {
        return VehicleModuleType.allTypes[intValue]
    }
}

@objc
public enum ObjCVehicleModuleType: Int {
    case unknown
    case chassis
    case engine
    case radios
    case turrets
    case guns
    case tank

    var stringValue: String {
        return VehicleModuleType.value(for: self.rawValue).rawValue
    }

    static func fromString(stringValue: String) -> ObjCVehicleModuleType {
        guard let index = VehicleModuleType(rawValue: stringValue)?.index else { fatalError("wrong string value: \(stringValue)")}
        guard let result = ObjCVehicleModuleType(rawValue: index) else { fatalError("unknown moduleType")}
        return result
    }
}

@objc
public class ObjCVehicleModuleTypeConverter: NSObject {
    @objc
    @available(*, deprecated, message: "Use swift VehicleModuleType")
    public static func fromString(_ string: String) -> ObjCVehicleModuleType {
        return ObjCVehicleModuleType.fromString(stringValue: string)
    }
}

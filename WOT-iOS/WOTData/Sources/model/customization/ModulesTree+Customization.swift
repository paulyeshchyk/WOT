//
//  ModulesTree+Customization.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - Customization

extension ModulesTree {
    @objc
    public func moduleType() -> ObjCVehicleModuleType {
        return .unknown
    }

    @objc
    public func localImageURL() -> URL? {
        let type = self.moduleType()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }
}

public enum VehicleModuleType: String {
    case unknown
    case vehicleChassis
    case vehicleEngine
    case vehicleRadio
    case vehicleTurret
    case vehicleGun
    case tank

    public static func fromString(_ string: String?) -> VehicleModuleType {
        guard let string = string else {
            fatalError("incompatible module type: nil")
        }
        guard let result = VehicleModuleType(rawValue: string) else {
            fatalError("incompatible module type: \(string)")
        }
        return result
    }

    private static var allTypes: [VehicleModuleType] = [.unknown, .vehicleChassis, .vehicleEngine, .vehicleRadio, .vehicleTurret, .vehicleGun, .tank]

    var index: Int {
        if let result = VehicleModuleType.allTypes.firstIndex(of: self) {
            return result
        }
        fatalError("VehicleModuleType.alltypes has no value:\(self)")
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
@available(*, deprecated, message: "Use swift VehicleModuleType")
public class ObjCVehicleModuleTypeConverter: NSObject {
    @objc
    public static func fromString(_ string: String) -> ObjCVehicleModuleType {
        return ObjCVehicleModuleType.fromString(stringValue: string)
    }
}

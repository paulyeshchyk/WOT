//
//  ModulesTree+Customization.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - Customization

public extension ModulesTree {
    @objc
    func moduleType_() -> ObjCVehicleModuleType {
        return .unknown
    }

    @objc
    func localImageURL() -> URL? {
        let type = moduleType_()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }
}

// MARK: - VehicleModuleType

public enum VehicleModuleType: String {
    case vehicleChassis
    case vehicleEngine
    case vehicleRadio
    case vehicleTurret
    case vehicleGun

    var index: Int {
        if let result = VehicleModuleType.allTypes.firstIndex(of: self) {
            return result
        }
        fatalError("VehicleModuleType.alltypes has no value:\(self)")
    }

    private static var allTypes: [VehicleModuleType] = [.vehicleChassis, .vehicleEngine, .vehicleRadio, .vehicleTurret, .vehicleGun]

    // MARK: Public

    public static func fromString(_ string: String?) throws -> VehicleModuleType {
        guard let string = string else {
            throw ModuleMappingError.cantUseNil
        }
        guard let result = VehicleModuleType(rawValue: string) else {
            throw ModuleMappingError.unexpectedModuleType(string)
        }
        return result
    }

    // MARK: Internal

    static func value(for intValue: Int) -> VehicleModuleType {
        return VehicleModuleType.allTypes[intValue]
    }
}

// MARK: - ModuleMappingError

private enum ModuleMappingError: Error {
    case cantUseNil
    case unexpectedModuleType(String)
}

// MARK: - ObjCVehicleModuleType

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
        return VehicleModuleType.value(for: rawValue).rawValue
    }

    // MARK: Internal

    static func fromString(stringValue: String) -> ObjCVehicleModuleType {
        guard let index = VehicleModuleType(rawValue: stringValue)?.index else { fatalError("wrong string value: \(stringValue)") }
        guard let result = ObjCVehicleModuleType(rawValue: index) else { fatalError("unknown moduleType") }
        return result
    }
}

// MARK: - ObjCVehicleModuleTypeConverter

@objc
@available(*, deprecated, message: "Use swift VehicleModuleType")
public class ObjCVehicleModuleTypeConverter: NSObject {
    @objc
    public static func fromString(_ string: String) -> ObjCVehicleModuleType {
        return ObjCVehicleModuleType.fromString(stringValue: string)
    }
}

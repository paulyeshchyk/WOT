//
//  Module+Customization.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

// MARK: - ModuleType

public enum ModuleType: String {
    case unknown
    case suspension
    case engine
    case radios
    case turrets
    case guns
    case tank

    var index: Int {
        guard let result = ModuleType.allTypes.firstIndex(of: self) else { fatalError("ModuleType.alltypes has no value:\(self)") }
        return result
    }

    static func value(for intValue: Int) -> ModuleType {
        return ModuleType.allTypes[intValue]
    }

    private static var allTypes: [ModuleType] = [.unknown, .suspension, .engine, .radios, .turrets, .guns, .tank]
}

// MARK: - ObjCModuleType

@objc
public enum ObjCModuleType: Int {
    case unknown
    case chassis
    case engine
    case radios
    case turrets
    case guns
    case tank

    var stringValue: String {
        return ModuleType.value(for: rawValue).rawValue
    }

    static func fromString(stringValue: String) -> ObjCModuleType {
        guard let index = ModuleType(rawValue: stringValue)?.index else { fatalError("wrong string value: \(stringValue)") }
        guard let result = ObjCModuleType(rawValue: index) else { fatalError("unknown moduleType") }
        return result
    }
}

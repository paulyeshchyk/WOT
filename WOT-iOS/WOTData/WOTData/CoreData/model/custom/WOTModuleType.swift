//
//  WOTModuleType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum WOTModuleType: Int {
    case unknown
    case chassis
    case engine
    case radios
    case turrets
    case guns
    case tank
    
    var stringValue: String {
        switch self {
        case .unknown: return "unknown"
        case .chassis: return "chassis"
        case .engine: return "engine"
        case .radios: return "radios"
        case .turrets: return "turrets"
        case .guns: return "guns"
        case .tank: return "tank"
        }
    }
    
    static func fromString(stringValue: String) -> WOTModuleType {
        switch stringValue.lowercased() {
        case "unknown":return .unknown
        case "chassis":return .chassis
        case "engine":return .engine
        case "radios":return .radios
        case "turrets":return .turrets
        case "guns":return .guns
        case "tank":return .tank
        #warning("WTF")
        default: return .unknown
        }
    }
}

@objc
public class WOTModuleTypeOBJcConverter: NSObject {

    @objc
    public static func fromString(_ string: String) -> WOTModuleType {
        return WOTModuleType.fromString(stringValue: string)
    }
}

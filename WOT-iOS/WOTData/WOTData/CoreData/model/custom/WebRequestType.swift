//
//  WebRequestType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum WebRequestType: String {
    case unknown
    case login
    case logout
    case sessionSave
    case sessionClear
    case suspension
    case turrets
    case guns
    case radios
    case engines
    case vehicles
    case moduleTree
    case tankProfile

    private static var allTypes: [WebRequestType] = [.unknown, .login, .logout, .sessionSave, .sessionClear, .suspension, .turrets, .guns, .radios, .engines, .vehicles, .moduleTree, .tankProfile]

    var index: Int {
        guard let result = WebRequestType.allTypes.firstIndex(of: self) else { fatalError("WebRequestType.alltypes has no value:\(self)")}
        return result
    }

    static func value(for intValue: Int) -> WebRequestType {
        return WebRequestType.allTypes[intValue]
    }
}

@objc
public enum ObjCWebRequestType: Int {
    case unknown
    case login
    case logout
    case saveSession
    case clearSession
    case chassis
    case turrets
    case guns
    case radios
    case engines
    case vehicles
    case moduleTree
    case tankProfile

    var stringValue: String {
        return WebRequestType.value(for: self.rawValue).rawValue
    }

    static func fromString(stringValue: String) -> ObjCWebRequestType {
        guard let index = WebRequestType(rawValue: stringValue)?.index else { fatalError("wrong string value: \(stringValue)")}
        guard let result = ObjCWebRequestType(rawValue: index) else { fatalError("unknown WebRequestType")}
        return result
    }
}

@objc
public class ObjCWebRequestTypeConverter: NSObject {
    @objc
    @available(*, deprecated, message: "Use swift ModuleType")
    public static func fromString(_ string: String) -> ObjCWebRequestType {
        return ObjCWebRequestType.fromString(stringValue: string)
    }
}

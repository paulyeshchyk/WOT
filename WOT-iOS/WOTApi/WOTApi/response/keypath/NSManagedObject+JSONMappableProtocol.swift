//
//  NSManagedObject+JSONMappableProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import CoreData
import ContextSDK

extension NSManagedObject: JSONMappableProtocol {

    private enum NSManagedObjectJSONMappableError: Error, CustomStringConvertible {
        case shouldBeOverriden(String)
        var description: String {
            switch self {
            case .shouldBeOverriden(let text): return "\(type(of: self)): '\(text)' should be overridden"
            }
        }
    }

    public enum DataFieldsKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = DataFieldsKeys

    @objc
    open func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        throw NSManagedObjectJSONMappableError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}


//
//  NSManagedObject+JSONMappableProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

extension NSManagedObject: JSONDecodableProtocol {
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
    open func decode(using _: JSONMapProtocol, managedObjectContextContainer _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        throw NSManagedObjectJSONMappableError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}

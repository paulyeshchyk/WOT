//
//  NSManagedObject+JSONMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import ContextSDK

extension NSManagedObject: JSONMappableProtocol {

    private enum NSManagedObjectJSONMappableError: Error {
        case shouldBeOverriden(String)
        var description: String {
            switch self {
            case .shouldBeOverriden(let text): return "\(type(of: self)): '\(text)' should be overridden"
            }
        }
    }

    public enum FieldKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = FieldKeys

    @objc
    open func mapping(jsonmap: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        throw NSManagedObjectJSONMappableError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    @objc
    open func mapping(arraymap: ArrayManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        throw NSManagedObjectJSONMappableError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}

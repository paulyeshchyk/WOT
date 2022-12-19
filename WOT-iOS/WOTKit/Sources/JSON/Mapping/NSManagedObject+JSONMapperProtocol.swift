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
    public enum FieldKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = FieldKeys

    @objc
    open func mapping(json: JSON, objectContext: ObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    @objc
    open func mapping(array: [Any], objectContext: ObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}

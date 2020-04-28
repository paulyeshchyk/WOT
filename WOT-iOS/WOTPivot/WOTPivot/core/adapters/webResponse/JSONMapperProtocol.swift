//
//  JSONMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias JSON = Swift.Dictionary<Swift.AnyHashable, Any>

public protocol JSONMapperProtocol {
    associatedtype Fields

    mutating func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON)
    func mapping(context: NSManagedObjectContext, fromArray array: [Any])

    func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws
    func mapping(context: NSManagedObjectContext, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: DataAdapterProtocol?) throws
}

extension JSONMapperProtocol {
    public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON) {}
    public func mapping(context: NSManagedObjectContext, fromArray array: [Any]) {}
    public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {}
    public func mapping(context: NSManagedObjectContext, fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: DataAdapterProtocol?) throws {}
}

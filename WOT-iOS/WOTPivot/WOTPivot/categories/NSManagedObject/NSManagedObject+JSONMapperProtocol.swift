//
//  NSManagedObject+JSONMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObject: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = FieldKeys

    @objc
    open func mapping(fromArray array: [Any]) {
        fatalError("not implemented")
    }

    @objc
    open func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        fatalError("not implemented")
    }

    @objc
    open func mapping(fromArray array: [Any], pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        fatalError("not implemented")
    }
}

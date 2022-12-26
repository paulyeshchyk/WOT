//
//  NSManagedObject+KeypathProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import ContextSDK

extension NSManagedObject: RequestableProtocol {
    @objc
    open class func dataFieldsKeypaths() -> [String] {
        return []
    }

    @objc
    open class func relationFieldsKeypaths() -> [String] {
        return []
    }

    @objc
    public static func fieldsKeypaths() -> [String] {
        let fields = dataFieldsKeypaths()
        let relations = relationFieldsKeypaths()
        return fields + relations
    }
}

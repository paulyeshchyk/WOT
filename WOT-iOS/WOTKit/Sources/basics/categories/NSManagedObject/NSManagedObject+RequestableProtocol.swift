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
    open class func fieldsKeypaths() -> [String] {
        return []
    }

    @objc
    open class func relationsKeypaths() -> [String] {
        return []
    }

    @objc
    public static func classKeypaths() -> [String] {
        let fields = fieldsKeypaths()
        let relations = relationsKeypaths()
        return fields + relations
    }
}

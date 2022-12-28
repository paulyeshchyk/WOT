//
//  NSManagedObject+RequestableProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
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

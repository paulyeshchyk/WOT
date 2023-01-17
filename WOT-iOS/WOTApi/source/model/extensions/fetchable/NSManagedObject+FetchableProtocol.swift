//
//  NSManagedObject+RequestableProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

extension NSManagedObject: FetchableProtocol {
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

//
//  NSManagedObject+PrimaryKeypathProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObject: PrimaryKeypathProtocol {
    open class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        fatalError("Primary ID keypath is not defined")
    }

    open class func predicateFormat(forType: PrimaryKeyType) -> String {
        return "%K == %@"
    }

    open class func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        let predicateTemplate = predicateFormat(forType: andType)
        let keyName = primaryKeyPath(forType: .internal)
        return NSPredicate(format: predicateTemplate, keyName, ident)
    }

    open class func primaryKey(for ident: Any, andType: PrimaryKeyType) -> WOTPrimaryKey? {
        let predicateTemplate = predicateFormat(forType: andType)
        let keyName = primaryKeyPath(forType: andType)
        return WOTPrimaryKey(name: keyName, value: ident as AnyObject, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}

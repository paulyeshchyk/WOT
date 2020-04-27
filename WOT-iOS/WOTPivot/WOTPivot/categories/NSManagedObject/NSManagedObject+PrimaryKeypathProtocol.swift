//
//  NSManagedObject+PrimaryKeypathProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObject: PrimaryKeypathProtocol {
    open class func primaryKeyPath() -> String {
        fatalError("Primary keypath is not defined")
    }

    open class func primaryIdKeyPath() -> String {
        fatalError("Primary ID keypath is not defined")
    }

    open class func predicateFormat() -> String {
        return "%K == %@"
    }

    open class func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        let predicateTemplate = predicateFormat()
        let keyName = primaryKeyPath()
        return NSPredicate(format: predicateTemplate, keyName, ident)
    }

    open class func primaryKey(for ident: Any) -> WOTPrimaryKey {
        let predicateTemplate = predicateFormat()
        let keyName = primaryKeyPath()
        return WOTPrimaryKey(name: keyName, value: ident as AnyObject, nameAlias: keyName, predicateFormat: predicateTemplate)
    }

    open class func primaryIdKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        let predicateTemplate = predicateFormat()
        let keyName = primaryIdKeyPath()
        return WOTPrimaryKey(name: keyName, value: ident as AnyObject, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}

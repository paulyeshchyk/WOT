//
//  NSManagedObject+PrimaryKeypathProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObject: PrimaryKeypathProtocol {
    open class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        return nil
    }

    open class func predicateFormat(forType: PrimaryKeyType) -> String {
        return "%K == %@"
    }

    open class func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        guard let keyName = primaryKeyPath(forType: .internal) else { return nil }
        let predicateTemplate = predicateFormat(forType: andType)
        return NSPredicate(format: predicateTemplate, keyName, ident)
    }

    open class func primaryKey(for ident: AnyObject?, andType: PrimaryKeyType) -> WOTPrimaryKey? {
        guard let keyName = primaryKeyPath(forType: andType) else { return nil }
        guard let ident = ident else { return nil }
        let predicateTemplate = predicateFormat(forType: andType)
        return WOTPrimaryKey(name: keyName, value: ident, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}

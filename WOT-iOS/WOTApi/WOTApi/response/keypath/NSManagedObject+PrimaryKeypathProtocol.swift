//
//  NSManagedObject+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import CoreData
import ContextSDK

extension PrimaryKeyType {
    var nsManagedObjectFormat: PredicateFormat {
        switch self {
        case .external: return .external
        case .internal: return .internal
        }
    }
}

private class NSManagedObjectPredicateFormat: PredicateFormatProtocol {
    private let keyType: PrimaryKeyType
    init(keyType: PrimaryKeyType) {
        self.keyType = keyType
    }
    public var template: String {
        switch keyType {
        case .external: return "%K == %@"
        case .internal: return "%K = %@"
        }
    }
}

extension NSManagedObject: PrimaryKeypathProtocol {
    open class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        return nil
    }

    open class func predicateFormat(forType: PrimaryKeyType) -> PredicateFormatProtocol {
        return NSManagedObjectPredicateFormat(keyType: forType)
    }

    open class func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        guard let keyName = primaryKeyPath(forType: .internal) else { return nil }
        let predicateTemplate = predicateFormat(forType: andType).template
        return NSPredicate(format: predicateTemplate, keyName, ident)
    }

    open class func primaryKey(for ident: AnyObject?, andType: PrimaryKeyType) -> ContextExpression? {
        guard let keyName = primaryKeyPath(forType: andType) else { return nil }
        guard let ident = ident else { return nil }
        let predicateTemplate = predicateFormat(forType: andType).template
        return ContextExpression(name: keyName, value: ident, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}


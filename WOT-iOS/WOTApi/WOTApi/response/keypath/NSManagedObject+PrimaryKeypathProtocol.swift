//
//  NSManagedObject+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

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
    open class func primaryKeyPath(forType _: PrimaryKeyType) -> String {
        fatalError("should be overriden")
    }

    open class func predicateFormat(forType: PrimaryKeyType) -> PredicateFormatProtocol {
        return NSManagedObjectPredicateFormat(keyType: forType)
    }

    open class func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        let keyName = primaryKeyPath(forType: .internal)
        let predicateTemplate = predicateFormat(forType: andType).template
        return NSPredicate(format: predicateTemplate, keyName, ident)
    }

    open class func primaryKey(forType: PrimaryKeyType, andObject: JSONValueType?) -> ContextExpression? {
        guard let ident = andObject else { return nil }
        let keyName = primaryKeyPath(forType: forType)
        let predicateTemplate = predicateFormat(forType: forType).template
        return ContextExpression(name: keyName, value: ident, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}

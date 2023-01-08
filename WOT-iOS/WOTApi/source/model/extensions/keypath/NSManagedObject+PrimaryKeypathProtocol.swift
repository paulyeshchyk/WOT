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
        default: fatalError("unknown type should never be used")
        }
    }
}

// MARK: - NSManagedObjectPredicateFormat

private class NSManagedObjectPredicateFormat: PredicateFormatProtocol {

    public var template: String {
        switch keyType {
        case .external: return "%K == %@"
        case .internal: return "%K = %@"
        default: fatalError("unknown type should never be used")
        }
    }

    private let keyType: PrimaryKeyType

    // MARK: Lifecycle

    init(keyType: PrimaryKeyType) {
        self.keyType = keyType
    }

}

// MARK: - NSManagedObject + PrimaryKeypathProtocol

extension NSManagedObject: PrimaryKeypathProtocol {
    open class func primaryKeyPath(forType _: PrimaryKeyType) -> String {
        fatalError("has not been implemented")
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

    open class func primaryKey(forType: PrimaryKeyType, andObject: JSONValueType?) -> ContextExpressionProtocol? {
        guard let ident = andObject else { return nil }
        let keyName = primaryKeyPath(forType: forType)
        let predicateTemplate = predicateFormat(forType: forType).template
        return ContextExpression(name: keyName, value: ident, nameAlias: keyName, predicateFormat: predicateTemplate)
    }
}

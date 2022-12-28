//
//  PrimaryKeypathProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public enum PrimaryKeyType: Int {
    case `internal`
    case `external`
}

@objc
public protocol PredicateFormatProtocol {
    var template: String { get }
}

@objc
public enum PredicateFormat: Int {
    case `external`
    case `internal`
}

@objc
public protocol PrimaryKeypathProtocol: AnyObject {
    static func predicateFormat(forType: PrimaryKeyType) -> PredicateFormatProtocol
    static func predicate(for ident: AnyObject?, andType: PrimaryKeyType) -> NSPredicate?
    static func primaryKeyPath(forType: PrimaryKeyType) -> String?
    static func primaryKey(forType: PrimaryKeyType, andObject: AnyObject?) -> ContextExpression?
}

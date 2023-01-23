//
//  PrimaryKeypathProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

// MARK: - PrimaryKeypathProtocol

@objc
public protocol PrimaryKeypathProtocol {
    static func predicateFormat(forType: PrimaryKeyType) -> PredicateFormatProtocol
    static func primaryKeyPath(forType: PrimaryKeyType) -> String
    static func primaryKey(forType: PrimaryKeyType, andObject: JSONValueType?) -> ContextExpressionProtocol?
}

// MARK: - PrimaryKeyType

@objc
public enum PrimaryKeyType: Int {
    case `internal`
    case `external`
}

// MARK: - PredicateFormatProtocol

@objc
public protocol PredicateFormatProtocol {
    var template: String { get }
}

// MARK: - PredicateFormat

@objc
public enum PredicateFormat: Int {
    case `external`
    case `internal`
}

//
//  JSONMap.swift
//  ContextSDK
//
//  Created by Paul on 31.12.22.
//

// MARK: - JSONMapProtocol

@objc
public protocol JSONMapProtocol: JSONCollectionContainerProtocol, ContextPredicateContainerProtocol {
    var description: String { get }
}

extension JSONMapProtocol {
    public func data<T>(ofType _: T.Type) throws -> T? {
        try jsonCollection.data(ofType: T.self)
    }
}

// MARK: - JSONMap

public class JSONMap: JSONMapProtocol {

    public var description: String {
        return "[\(type(of: self))]: data: \(String(describing: jsonCollection)), predicate: \(String(describing: contextPredicate))"
    }

    public let contextPredicate: ContextPredicateProtocol
    public let jsonCollection: JSONCollectionProtocol

    // MARK: Lifecycle

    public init(jsonCollection: JSONCollectionProtocol?, predicate contextPredicate: ContextPredicateProtocol) throws {
        guard let jsonCollection = jsonCollection else {
            throw JSONMapError.jsonIsNil
        }
        self.jsonCollection = jsonCollection
        self.contextPredicate = contextPredicate
    }

    public convenience init(element: JSON, predicate contextPredicate: ContextPredicateProtocol) throws {
        let collection = try JSONCollection(element: element)
        try self.init(jsonCollection: collection, predicate: contextPredicate)
    }

    public convenience init(array: [JSON], predicate contextPredicate: ContextPredicateProtocol) throws {
        let collection = try JSONCollection(array: array)
        try self.init(jsonCollection: collection, predicate: contextPredicate)
    }

    public convenience init(custom: Any, predicate contextPredicate: ContextPredicateProtocol) throws {
        let collection = JSONCollection(custom: custom)
        try self.init(jsonCollection: collection, predicate: contextPredicate)
    }
}

// MARK: - JSONMapError

private enum JSONMapError: Error, CustomStringConvertible {
    case jsonIsNil

    public var description: String {
        switch self {
        case .jsonIsNil: return "[\(type(of: self))]: json is nil"
        }
    }
}

// MARK: - JSONManagedObjectMapError

public enum JSONManagedObjectMapError: Error, CustomStringConvertible {
    case notAnElement(JSONCollectionContainerProtocol)
    case notAnArray(JSONCollectionContainerProtocol)

    public var description: String {
        switch self {
        case .notAnArray(let map): return "[\(type(of: self))]: Not an array: \(String(describing: map))"
        case .notAnElement(let map): return "[\(type(of: self))]: Not an element: \(String(describing: map))"
        }
    }
}

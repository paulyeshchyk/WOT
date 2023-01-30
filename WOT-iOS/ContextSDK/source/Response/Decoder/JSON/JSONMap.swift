//
//  JSONMap.swift
//  ContextSDK
//
//  Created by Paul on 31.12.22.
//

// MARK: - JSONMapProtocol

@objc
public protocol JSONMapProtocol {
    var contextPredicate: ContextPredicateProtocol { get }
    var jsonCollection: JSONCollectionProtocol { get }
}

extension JSONMapProtocol {
    public func data<T>(ofType _: T.Type) throws -> T {
        try jsonCollection.data(ofType: T.self)
    }
}

// MARK: - JSONMap

public class JSONMap: JSONMapProtocol, CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "[\(type(of: self))] \(debugDescription)"
    }

    public var debugDescription: String {
        "predicate: \(String(describing: contextPredicate)), data: \(String(describing: jsonCollection))"
    }

    public let contextPredicate: ContextPredicateProtocol
    public let jsonCollection: JSONCollectionProtocol

    // MARK: Lifecycle

    public init(data jsonCollection: JSONCollectionProtocol, contextPredicate: ContextPredicateProtocol) throws {
        self.jsonCollection = jsonCollection
        self.contextPredicate = contextPredicate
    }

    public convenience init(data: Any, predicate contextPredicate: ContextPredicateProtocol) throws {
        let collection = JSONCollection(data: data)
        try self.init(data: collection, contextPredicate: contextPredicate)
    }

    deinit {
        //
    }
}

// MARK: - %t + JSONMap.Errors

extension JSONMap {
    private enum Errors: Error, CustomStringConvertible {
        case jsonIsNil

        public var description: String {
            switch self {
            case .jsonIsNil: return "[\(type(of: self))]: json is nil"
            }
        }
    }
}

// MARK: - JSONManagedObjectMapError

public enum JSONManagedObjectMapError: Error, CustomStringConvertible {
    case notAnElement(JSONMapProtocol)
    case notAnArray(JSONMapProtocol)

    public var description: String {
        switch self {
        case .notAnArray(let map): return "[\(type(of: self))]: Not an array: \(String(describing: map))"
        case .notAnElement(let map): return "[\(type(of: self))]: Not an element: \(String(describing: map))"
        }
    }
}

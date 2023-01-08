//
//  JSONMap.swift
//  ContextSDK
//
//  Created by Paul on 31.12.22.
//

// MARK: - JSONMap

public class JSONMap: JSONCollectionContainerProtocol {

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

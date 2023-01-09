//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
public typealias JSONValueType = Any
public typealias KeypathType = Swift.AnyHashable
public typealias JSON = [KeypathType: JSONValueType]

// MARK: - JSONDecodingProtocol

public protocol JSONDecodingProtocol {
    func decodeWith(_ decoder: Decoder) throws
}

// MARK: - JSONDecodableProtocol

public protocol JSONDecodableProtocol {
    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    func decode(using: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws
}

// MARK: - JSONCollectionContainerProtocol

@objc
public protocol JSONCollectionContainerProtocol: ContextPredicateContainerProtocol {
    var jsonCollection: JSONCollectionProtocol { get }
}

// MARK: - JSONCollectionProtocol

@objc
public protocol JSONCollectionProtocol {
    var collectionType: JSONCollectionType { get }
    func add(element: JSON?) throws
    func add(array: [JSON]?) throws
    func data() -> Any?
}

// MARK: - JSONCollectionType

@objc
public enum JSONCollectionType: Int, CustomStringConvertible {
    case element
    case array
    case custom

    public var description: String {
        switch self {
        case .element: return "element"
        case .array: return "array"
        case .custom: return "custom"
        }
    }
}

//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
public typealias JSONValueType = Any
public typealias JSON = [Swift.AnyHashable: JSONValueType]

public protocol JSONDecodingProtocol {
    func decodeWith(_ decoder: Decoder) throws
}

public protocol JSONDecodableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol & LogInspectorContainerProtocol

    func decode(using: JSONCollectionContainerProtocol, appContext: JSONDecodableProtocol.Context) throws
}

@objc
public protocol JSONCollectionContainerProtocol: ContextPredicateContainerProtocol, ManagedObjectContextContainerProtocol {
    var jsonCollection: JSONCollectionProtocol { get }
}

@objc
public protocol JSONCollectionProtocol {
    var collectionType: JSONCollectionType { get }
    func add(element: JSON?) throws
    func add(array: [JSON]?) throws
    func data() -> Any?
}

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
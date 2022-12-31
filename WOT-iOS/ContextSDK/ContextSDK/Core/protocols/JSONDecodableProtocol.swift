//
//  JSONDecodableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol JSONDecodableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol & LogInspectorContainerProtocol

    func decode(using: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws
}

public enum JSONManagedObjectMapError: Error, CustomStringConvertible {
    case notAnElement(JSONManagedObjectMapProtocol)
    case notAnArray(JSONManagedObjectMapProtocol)
    public var description: String {
        switch self {
        case .notAnArray(let map): return "[\(type(of: self))]: Not an array: \(String(describing: map))"
        case .notAnElement(let map): return "[\(type(of: self))]: Not an element: \(String(describing: map))"
        }
    }
}

public class JSONMap: JSONManagedObjectMapProtocol {
    public var mappingData: Any? {
        jsonCollectable.data()
    }

    public let managedObjectContext: ManagedObjectContextProtocol
    public let predicate: ContextPredicateProtocol
    private let jsonCollectable: JSONCollectable
    public init(json: JSONCollectable?, managedObjectContext: ManagedObjectContextProtocol, predicate: ContextPredicateProtocol) throws {
        guard let json = json else {
            throw JSONMapError.jsonIsNil
        }
        jsonCollectable = json
        self.managedObjectContext = managedObjectContext
        self.predicate = predicate
    }
}

public enum JSONMapError: Error, CustomStringConvertible {
    case jsonIsNil

    public var description: String {
        switch self {
        case .jsonIsNil: return "[\(type(of: self))]: json is nil"
        }
    }
}

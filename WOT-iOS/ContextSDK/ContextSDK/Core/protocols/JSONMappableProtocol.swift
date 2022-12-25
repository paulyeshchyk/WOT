//
//  JSONMappableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol JSONMappableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws
}

@objc
public protocol ManagedObjectContextContainer {
    var managedObjectContext: ManagedObjectContextProtocol { get }
}

@objc
public protocol ManagedObjectMapProtocol: RequestPredicateContainerProtocol, ManagedObjectContextContainer { }

@objc
public protocol JSONManagedObjectMapProtocol: ManagedObjectMapProtocol {
    var mappingData: Any? { get }
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
    public let predicate: RequestPredicate
    private let jsonCollectable: JSONCollectable
    public init(json: JSONCollectable, managedObjectContext: ManagedObjectContextProtocol, predicate: RequestPredicate) {
        self.jsonCollectable = json
        self.managedObjectContext = managedObjectContext
        self.predicate = predicate
    }
}

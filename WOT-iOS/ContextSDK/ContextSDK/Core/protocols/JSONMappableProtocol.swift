//
//  JSONMappableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol JSONMappableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    func mapping(jsonmap: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws
    func mapping(arraymap: ArrayManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws
}

@objc
public protocol ManagedObjectContextContainer {
    var managedObjectContext: ManagedObjectContextProtocol { get }
}

@objc
public protocol ManagedObjectMapProtocol: RequestPredicateContainerProtocol, ManagedObjectContextContainer { }

@objc
public protocol JSONManagedObjectMapProtocol: ManagedObjectMapProtocol {
    var json: JSON { get }
}

@objc
public protocol ArrayManagedObjectMapProtocol: ManagedObjectMapProtocol {
    var array: [Any] { get }
}

public class JSONMap: JSONManagedObjectMapProtocol {
    public let json: JSON
    public let managedObjectContext: ManagedObjectContextProtocol
    public let predicate: RequestPredicate
    public init(json: JSON, managedObjectContext: ManagedObjectContextProtocol, predicate: RequestPredicate) {
        self.json = json
        self.managedObjectContext = managedObjectContext
        self.predicate = predicate
    }
}

public class ArrayMap: ArrayManagedObjectMapProtocol {
    public let array: [Any]
    public let managedObjectContext: ManagedObjectContextProtocol
    public let predicate: RequestPredicate
    public init(array: [Any], managedObjectContext: ManagedObjectContextProtocol, predicate: RequestPredicate) {
        self.array = array
        self.managedObjectContext = managedObjectContext
        self.predicate = predicate
    }

}

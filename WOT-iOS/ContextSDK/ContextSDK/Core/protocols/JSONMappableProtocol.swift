//
//  JSONMappableProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol JSONMappableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, inContext: JSONMappableProtocol.Context) throws
    func mapping(array: [Any], objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, inContext: JSONMappableProtocol.Context) throws
}

public protocol JSONMapJSONProtocol {
    var json: JSON { get set }
    var managedObjectContext: ManagedObjectContextProtocol { get set }
    var predicate: RequestPredicateProtocol { get set }
}

public protocol JSONMapArrayProtocol {
    var json: [Any] { get set }
    var managedObjectContext: ManagedObjectContextProtocol { get set }
    var predicate: RequestPredicateProtocol { get set }
}

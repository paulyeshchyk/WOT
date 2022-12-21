//
//  FetchResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public enum FetchStatus: Int {
    case none
    case fetched
    case inserted
    case updated
    case recovered
}

@objc
public protocol FetchResultProtocol: AnyObject {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    var objectContext: ManagedObjectContextProtocol? { get set }
    func dublicate() -> FetchResultProtocol
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext context: ManagedObjectContextProtocol?) -> ManagedObjectProtocol?
}

@objc
public protocol ManagedObjectContextProtocol: AnyObject {
    var name: String? { get }
    func object(byID: AnyObject) -> AnyObject?
    func findOrCreateObject(forType: AnyObject, predicate: NSPredicate?) -> AnyObject?
    func hasTheChanges() -> Bool
    func saveContext()
}

@objc
public protocol ManagedObjectProtocol: AnyObject {
    var entityName: String { get }
}

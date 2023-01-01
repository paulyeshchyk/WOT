//
//  ManagedObjectContextProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

@objc
public protocol ManagedObjectContextContainerProtocol {
    var managedObjectContext: ManagedObjectContextProtocol { get }
}

@objc
public protocol ManagedObjectContextProtocol: ManagedObjectContextLookupProtocol, ManagedObjectContextSaveProtocol {
    var name: String? { get }
}

@objc
public protocol ManagedObjectContextLookupProtocol: AnyObject {
    typealias Context = LogInspectorContainerProtocol
    func object(byID: AnyObject) -> AnyObject?
    func findOrCreateObject(forType: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol?
    func execute(appContext: Context, with: @escaping (ManagedObjectContextProtocol) -> Void)
}

@objc
public protocol ManagedObjectContextSaveProtocol: AnyObject {
    typealias Context = LogInspectorContainerProtocol
    func hasTheChanges() -> Bool
    func save(appContext: Context, completion block: @escaping ThrowableCompletion)
}

@objc
public protocol ManagedObjectContextDeleteProtocol: AnyObject {
    func deleteAllObjects() throws
    func deleteAllObjectsForEntity(entity: AnyObject) throws
}

@objc
public protocol ManagedObjectProtocol: AnyObject {
    var entityName: String { get }
    var fetchStatus: FetchStatus { get }
    var managedObjectID: AnyObject { get }
}

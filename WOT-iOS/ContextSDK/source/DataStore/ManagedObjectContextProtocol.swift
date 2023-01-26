//
//  ManagedObjectContextProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - ManagedObjectContextContainerProtocol

@objc
public protocol ManagedObjectContextContainerProtocol {
    var managedObjectContext: ManagedObjectContextProtocol? { get }
}

// MARK: - ManagedObjectContextProtocol

@objc
public protocol ManagedObjectContextProtocol: ManagedObjectContextLookupProtocol, ManagedObjectContextSaveProtocol {
    typealias ContextCompletion = (ManagedObjectContextProtocol) -> Void

    var name: String? { get }
}

// MARK: - ManagedObjectContextLookupProtocol

@objc
public protocol ManagedObjectContextLookupProtocol: AnyObject {

    typealias Context = LogInspectorContainerProtocol

    func object(managedRef: ManagedRefProtocol?) throws -> ManagedObjectProtocol
    func findOrCreateObject(appContext: Context, modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol?
    func execute(appContext: Context, with: @escaping ManagedObjectContextProtocol.ContextCompletion)
}

// MARK: - ManagedObjectContextSaveProtocol

@objc
public protocol ManagedObjectContextSaveProtocol: AnyObject {

    typealias Context = LogInspectorContainerProtocol

    func hasTheChanges() -> Bool
    func save(appContext: Context, completion block: @escaping ThrowableCompletion)
}

// MARK: - ManagedObjectContextDeleteProtocol

@objc
public protocol ManagedObjectContextDeleteProtocol: AnyObject {
    func deleteAllObjects() throws
    func deleteAllObjectsForEntity(entity: AnyObject) throws
}

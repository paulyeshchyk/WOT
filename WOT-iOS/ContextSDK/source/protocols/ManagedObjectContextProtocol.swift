//
//  ManagedObjectContextProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - ManagedObjectContextContainerProtocol

@objc
public protocol ManagedObjectContextContainerProtocol {
    var managedObjectContext: ManagedObjectContextProtocol { get }
}

// MARK: - ManagedObjectContextProtocol

@objc
public protocol ManagedObjectContextProtocol: ManagedObjectContextLookupProtocol, ManagedObjectContextSaveProtocol {
    var name: String? { get }
}

// MARK: - ManagedObjectContextLookupProtocol

@objc
public protocol ManagedObjectContextLookupProtocol: AnyObject {
    typealias Context = LogInspectorContainerProtocol
    func object(byID: AnyObject) -> AnyObject?
    func findOrCreateObject(appContext: Context, modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol?
    func execute(appContext: Context, with: @escaping (ManagedObjectContextProtocol) -> Void)
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
    func deleteAllObjects(appContext: ManagedObjectContextSaveProtocol.Context) throws
    func deleteAllObjectsForEntity(appContext: ManagedObjectContextSaveProtocol.Context, entity: AnyObject) throws
}

// MARK: - ManagedObjectProtocol

@objc
public protocol ManagedObjectProtocol: FetchResultContainerProtocol {
    var entityName: String { get }
    var fetchStatus: FetchStatus { get }
    var managedObjectID: AnyObject { get }
}

extension ManagedObjectProtocol {
    public func fetchResult(context: ManagedObjectContextProtocol, predicate: NSPredicate? = nil, fetchStatus: FetchStatus? = nil) -> FetchResultProtocol {
        return FetchResult(objectID: managedObjectID, inContext: context, predicate: predicate, fetchStatus: fetchStatus ?? self.fetchStatus)
    }
}

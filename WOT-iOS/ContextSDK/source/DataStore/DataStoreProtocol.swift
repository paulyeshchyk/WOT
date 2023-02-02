//
//  DataStoreProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

public typealias ThrowableCompletion = (Error?) -> Void
public typealias ThrowableContextCompletion = (ManagedObjectContextProtocol, Error?) -> Void
public typealias DatastoreManagedObjectCompletion = (ManagedObjectProtocol, Error?) -> Void
public typealias DatastoreFetchResultCompletion = (FetchResultProtocol, Error?) -> Void

// MARK: - DataStoreContainerProtocol

@objc
public protocol DataStoreContainerProtocol {
    @objc var dataStore: DataStoreProtocol? { get set }
}

// MARK: - PerformMode

@objc
public enum PerformMode: Int {
    case read
    case readwrite
}

// MARK: - DataStoreProtocol

@objc
public protocol DataStoreProtocol {
    //
    @objc func workingContext() -> ManagedObjectContextProtocol

    @objc func newPrivateContext() -> ManagedObjectContextProtocol

    // @available(*, deprecated, message: "NSPredicate to be used; see developer.apple.com/documentation/coredata/nsmanagedobjectcontext (Concurrency)")
    @objc func perform(mode: PerformMode, block: @escaping ManagedObjectContextProtocol.ContextCompletion) throws

    @objc func fetchResultController(fetchRequest: AnyObject, managedObjectContext: ManagedObjectContextProtocol) throws -> AnyObject
    @objc func mainContextFetchResultController(fetchRequest: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject

    func fetch(modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion)
    func stash(managedObjectContext: ManagedObjectContextProtocol, completion: @escaping ThrowableContextCompletion)

    //
    func isClassValid(_: AnyObject) -> Bool
}

extension DataStoreProtocol {
    func mainContextFetchResultController(for request: AnyObject) throws -> AnyObject {
        return try mainContextFetchResultController(fetchRequest: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}

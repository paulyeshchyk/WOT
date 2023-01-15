//
//  DataStoreProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

public typealias ObjectContextCompletion = (ManagedObjectContextProtocol) -> Void
public typealias ThrowableCompletion = (Error?) -> Void
public typealias ThrowableContextCompletion = (ManagedObjectContextProtocol, Error?) -> Void
public typealias DatastoreManagedObjectCompletion = (ManagedObjectProtocol, Error?) -> Void
public typealias DatastoreFetchResultCompletion = (FetchResultProtocol, Error?) -> Void

// MARK: - DataStoreContainerProtocol

@objc
public protocol DataStoreContainerProtocol {
    @objc var dataStore: DataStoreProtocol? { get set }
}

// MARK: - DataStoreProtocol

@objc
public protocol DataStoreProtocol {
    //
    @available(*, deprecated)
    @objc func workingContext() -> ManagedObjectContextProtocol

    @available(*, deprecated)
    @objc func newPrivateContext() -> ManagedObjectContextProtocol

    @objc func perform(block: @escaping ObjectContextCompletion)

    @objc func fetchResultController(fetchRequest: AnyObject, managedObjectContext: ManagedObjectContextProtocol) throws -> AnyObject
    @objc func mainContextFetchResultController(fetchRequest: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject

    func fetch(modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion)

    func stash(managedObject: ManagedObjectProtocol, completion: @escaping DatastoreManagedObjectCompletion)
    func stash(managedObjectContext: ManagedObjectContextProtocol, completion: @escaping ThrowableContextCompletion)
    func stash(fetchResult: FetchResultProtocol, completion: @escaping DatastoreFetchResultCompletion)
    func stash(block: @escaping ThrowableContextCompletion)

    //
    func isClassValid(_: AnyObject) -> Bool
}

extension DataStoreProtocol {
    func mainContextFetchResultController(for request: AnyObject) throws -> AnyObject {
        return try mainContextFetchResultController(fetchRequest: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}

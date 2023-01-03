//
//  DataStoreProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

public typealias ObjectContextCompletion = (ManagedObjectContextProtocol) -> Void
public typealias ThrowableCompletion = (Error?) -> Void
public typealias ThrowableContextCompletion = (ManagedObjectContextProtocol?, Error?) -> Void

// MARK: - DataStoreContainerProtocol

@objc
public protocol DataStoreContainerProtocol {
    @objc var dataStore: DataStoreProtocol? { get set }
}

// MARK: - DataStoreProtocol

@objc
public protocol DataStoreProtocol {
    //
    @objc func workingContext() -> ManagedObjectContextProtocol
    @objc func newPrivateContext() -> ManagedObjectContextProtocol

    @objc func perform(block: @escaping ObjectContextCompletion)
    @objc func perform(managedObjectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion)

    @objc func fetchResultController(fetchRequest: AnyObject, managedObjectContext: ManagedObjectContextProtocol) throws -> AnyObject
    @objc func mainContextFetchResultController(fetchRequest: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject

    func fetch(modelClass: AnyObject, contextPredicate: ContextPredicateProtocol, managedObjectContext: ManagedObjectContextProtocol, completion: @escaping FetchResultCompletion)
    func fetch(modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion)

    func stash(managedObjectContext: ManagedObjectContextProtocol?, completion: @escaping ThrowableContextCompletion)
    func stash(block: @escaping ThrowableContextCompletion)
}

extension DataStoreProtocol {
    func mainContextFetchResultController(for request: AnyObject) throws -> AnyObject {
        return try mainContextFetchResultController(fetchRequest: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}

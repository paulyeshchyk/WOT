//
//  DataStoreProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

public typealias ObjectContextCompletion = (ManagedObjectContextProtocol) -> Void
public typealias ThrowableCompletion = (Error?) -> Void

@objc
public protocol DataStoreContainerProtocol {
    @objc var dataStore: DataStoreProtocol? { get set }
}

@objc
public protocol DataStoreProtocol {
    //
    @objc func workingContext() -> ManagedObjectContextProtocol
    @objc func newPrivateContext() -> ManagedObjectContextProtocol

    @objc func perform(block: @escaping ObjectContextCompletion)
    @objc func perform(managedObjectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion)

    @objc func fetchResultController(fetchRequest: AnyObject, managedObjectContext: ManagedObjectContextProtocol) throws -> AnyObject
    @objc func mainContextFetchResultController(fetchRequest: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject

    func fetchLocal(managedObjectContext: ManagedObjectContextProtocol, byModelClass clazz: AnyObject, contextPredicate: ContextPredicateProtocol, completion: @escaping FetchResultCompletion)
    func fetchLocal(byModelClass clazz: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion)

    func stash(managedObjectContext: ManagedObjectContextProtocol?, completion: @escaping ThrowableCompletion)
    func stash(block: @escaping ThrowableCompletion)
}

extension DataStoreProtocol {
    func mainContextFetchResultController(for request: AnyObject) throws -> AnyObject {
        return try mainContextFetchResultController(fetchRequest: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}

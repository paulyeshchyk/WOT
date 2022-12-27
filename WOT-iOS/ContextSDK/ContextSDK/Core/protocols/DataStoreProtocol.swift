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

    @objc func workingContext() -> ManagedObjectContextProtocol
    @objc func newPrivateContext() -> ManagedObjectContextProtocol

    @objc func perform(objectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion)

    @objc func fetchResultController(for request: AnyObject, andContext: ManagedObjectContextProtocol) throws -> AnyObject //NSFetchedResultsController<NSFetchRequestResult>
    @objc func mainContextFetchResultController(for request: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject

    func fetchLocal(objectContext: ManagedObjectContextProtocol, byModelClass clazz: AnyObject, predicate: ContextPredicate, completion: @escaping FetchResultCompletion)
    func fetchLocal(byModelClass clazz: PrimaryKeypathProtocol.Type, requestPredicate predicate: NSPredicate?, completion: @escaping FetchResultCompletion)

    func stash(objectContext: ManagedObjectContextProtocol?, block: @escaping ThrowableCompletion)
    func stash(block: @escaping ThrowableCompletion)
}

extension DataStoreProtocol {
    func mainContextFetchResultController(for request: AnyObject) throws -> AnyObject {
        return try self.mainContextFetchResultController(for: request, sectionNameKeyPath: nil, cacheName: nil)
    }
}
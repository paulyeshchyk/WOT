//
//  DataStore.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - DataStore

open class DataStore {

    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol

    public let appContext: Context

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

}

// MARK: - DataStoreError

private enum DataStoreError: Error, CustomStringConvertible {
    case noKeysDefinedForClass(String)
    case clazzIsNotSupportable(String)
    case contextNotSaved
    case contextNotDefined
    case objectNotCreated(AnyClass)
    case notManagedObjectType(PrimaryKeypathProtocol.Type)

    public var description: String {
        switch self {
        case .noKeysDefinedForClass(let clazz): return "[\(type(of: self))]: No keys defined for:[\(String(describing: clazz))]"
        case .contextNotSaved: return "\(type(of: self)): Context is not saved"
        case .objectNotCreated(let clazz): return "\(type(of: self)): Object is not created:[\(String(describing: clazz))]"
        case .clazzIsNotSupportable(let clazz): return "\(type(of: self)): Class is not supported by mapper:[\(String(describing: clazz))]"
        case .notManagedObjectType(let clazz): return "[\(type(of: self))]: Not ManagedObjectType:[\(String(describing: clazz))]"
        case .contextNotDefined: return "[\(type(of: self))]: Context is not defined"
        }
    }
}

// MARK: - DataStore + DataStoreProtocol

extension DataStore: DataStoreProtocol {

    open func isClassValid(_: AnyObject) -> Bool {
        fatalError("has not been implemented")
    }

    open func emptyFetchResult() throws -> FetchResultProtocol {
        fatalError("has not been implemented")
    }

    @objc
    open func newPrivateContext() -> ManagedObjectContextProtocol {
        fatalError("has not been implemented")
    }

    @objc
    open func workingContext() -> ManagedObjectContextProtocol {
        fatalError("has not been implemented")
    }

    open func fetchResultController(fetchRequest _: AnyObject, managedObjectContext _: ManagedObjectContextProtocol) throws -> AnyObject {
        fatalError("has not been implemented")
    }

    open func mainContextFetchResultController(fetchRequest _: AnyObject, sectionNameKeyPath _: String?, cacheName _: String?) throws -> AnyObject {
        fatalError("has not been implemented")
    }

    open func perform(block: @escaping ObjectContextCompletion) {
        perform(managedObjectContext: workingContext(), block: block)
    }

    private func perform(managedObjectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion) {
        managedObjectContext.execute(appContext: appContext, with: block)
    }

    public func stash(managedObject: ManagedObjectProtocol, completion: @escaping DatastoreManagedObjectCompletion) {
        guard let managedObjectContext = managedObject.context else {
            completion(managedObject, DataStoreStashError.contextNotFound(managedObject))
            return
        }
        managedObjectContext.save(appContext: appContext, completion: { error in
            completion(managedObject, error)
        })
    }

    public func stash(fetchResult: FetchResultProtocol, completion: @escaping DatastoreFetchResultCompletion) {
        fetchResult.managedObjectContext.save(appContext: appContext) { error in
            completion(fetchResult, error)
        }
    }

    public func stash(block: @escaping ThrowableContextCompletion) {
        stash(managedObjectContext: workingContext(), completion: block)
    }

    public func stash(managedObjectContext: ManagedObjectContextProtocol, completion: @escaping ThrowableContextCompletion) {
        managedObjectContext.save(appContext: appContext) { error in
            completion(managedObjectContext, error)
        }
    }

    public func fetch(modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, managedObjectContext: ManagedObjectContextProtocol?, completion: @escaping FetchResultCompletion) {
        //
        guard isClassValid(modelClass) else {
            completion(nil, DataStoreError.notManagedObjectType(modelClass))
            return
        }

        let privateManagedObjectContext = newPrivateContext()
        privateManagedObjectContext.execute(appContext: appContext) { [weak self] privateManagedObjectContext in
            guard let self = self else {
                completion(nil, DataStoreStashError.datastoreIsNil)
                return
            }

            guard let managedObject = privateManagedObjectContext.findOrCreateObject(modelClass: modelClass, predicate: nspredicate) else {
                completion(nil, DataStoreError.objectNotCreated(modelClass))
                return
            }
            self.stash(managedObjectContext: privateManagedObjectContext) { context, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                let originalFetchResult = managedObject.fetchResult(context: context)

                let finalManagedObjectContext = managedObjectContext ?? self.workingContext()
                finalManagedObjectContext.execute(appContext: self.appContext) { context in
                    let fetchResult = originalFetchResult.makeDublicate(managedObjectContext: context)
                    completion(fetchResult, nil)
                }
            }
        }
    }
}

// MARK: - DataStoreStashError

private enum DataStoreStashError: Error, CustomStringConvertible {
    case contextNotFound(ManagedObjectProtocol)
    case datastoreIsNil

    var description: String {
        switch self {
        case .contextNotFound(let managedObject): return "\(type(of: self)) Context not found for \(String(describing: managedObject))"
        case .datastoreIsNil: return "\(type(of: self)) Datastore is nil"
        }
    }
}

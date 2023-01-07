//
//  DataStore.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - DataStore

open class DataStore {

    public required init(appContext: Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    public enum DataStoreError: Error, CustomStringConvertible {
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

    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol

    public let appContext: Context
}

// MARK: - DataStore + DataStoreProtocol

extension DataStore: DataStoreProtocol {

    open func isClassValid(_: AnyObject) -> Bool {
        fatalError("has not been implemented")
    }

    open func emptyFetchResult() throws -> FetchResultProtocol {
        fatalError("has not been implemented")
    }

    open func newPrivateContext() -> ManagedObjectContextProtocol {
        fatalError("has not been implemented")
    }

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
        workingContext().execute(appContext: appContext) { context in
            block(context)
        }
    }

    open func perform(managedObjectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion) {
        managedObjectContext.execute(appContext: appContext) { context in
            block(context)
        }
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

    public func fetch(modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion) {
        let localCallback: FetchResultCompletion = { fetchResult, error in
            self.workingContext().execute(appContext: self.appContext) { managedObjectContext in
                let fetchResultForContext = fetchResult?.makeDublicate(inContext: managedObjectContext)
                completion(fetchResultForContext, error)
            }
        }

        guard isClassValid(modelClass) else {
            do {
                let error = DataStoreError.notManagedObjectType(modelClass)
                let result = try emptyFetchResult()
                completion(result, error)
            } catch {
                completion(nil, error)
            }
            return
        }

        let managedObjectContext = newPrivateContext()
        perform(managedObjectContext: managedObjectContext) { [weak self] managedObjectContext in
            guard let self = self else {
                return
            }

            guard let managedObject = managedObjectContext.findOrCreateObject(modelClass: modelClass, predicate: nspredicate) else {
                self.appContext.logInspector?.log(.error(DataStoreError.objectNotCreated(modelClass)), sender: self)
                return
            }
            self.stash(managedObjectContext: managedObjectContext) { context, error in
                guard let context = context else {
                    localCallback(nil, error)
                    return
                }

                let fetchResult = managedObject.fetchResult(context: context)
                localCallback(fetchResult, error)
            }
        }
    }

    public func fetch(modelClass: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicateProtocol, managedObjectContext: ManagedObjectContextProtocol, completion: @escaping FetchResultCompletion) {
        guard isClassValid(modelClass) else {
            do {
                let error = DataStoreError.clazzIsNotSupportable(String(describing: modelClass))
                appContext.logInspector?.log(.error(error), sender: self)
                let result = try emptyFetchResult()
                completion(result, error)
            } catch {
                completion(nil, error)
            }
            return
        }

        guard let predicate = contextPredicate.nspredicate(operator: .and) else {
            let error = DataStoreError.noKeysDefinedForClass(String(describing: modelClass))
            let fetchResult = FetchResult(objectID: nil, inContext: managedObjectContext, predicate: nil, fetchStatus: .fetched)
            completion(fetchResult, error)
            return
        }

        perform(managedObjectContext: managedObjectContext) { [weak self] managedObjectContext in
            guard let self = self else {
                completion(nil, nil)
                return
            }
            if let managedObject = managedObjectContext.findOrCreateObject(modelClass: modelClass, predicate: predicate) {
                let fetchResult = managedObject.fetchResult(context: managedObjectContext)// FetchResult(objectID: managedObject.managedObjectID, inContext: managedObjectContext, predicate: predicate, fetchStatus: managedObject.fetchStatus)
                completion(fetchResult, nil)
            } else {
                do {
                    let result = try self.emptyFetchResult()
                    completion(result, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}

// MARK: - DataStoreStashError

private enum DataStoreStashError: Error, CustomStringConvertible {
    case contextNotFound(ManagedObjectProtocol)

    var description: String {
        switch self {
        case .contextNotFound(let managedObject): return "\(type(of: self)) Context not found for \(String(describing: managedObject))"
        }
    }
}

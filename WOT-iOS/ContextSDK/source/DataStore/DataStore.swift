//
//  DataStore.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

open class DataStore {
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

    public typealias Context = LogInspectorContainerProtocol

    public let appContext: Context

    public required init(appContext: Context) {
        self.appContext = appContext
    }

    open func isClassValid(_: AnyObject) -> Bool {
        fatalError("should be overriden")
    }

    open func emptyFetchResult() -> FetchResultProtocol {
        fatalError("should be overriden")
    }
}

// MARK: - DataStoreProtocol

extension DataStore: DataStoreProtocol {
    open func newPrivateContext() -> ManagedObjectContextProtocol {
        fatalError("should be overriden")
    }

    open func workingContext() -> ManagedObjectContextProtocol {
        fatalError("should be overriden")
    }

    open func fetchResultController(for _: AnyObject, andContext _: ManagedObjectContextProtocol) throws -> AnyObject {
        fatalError("should be overriden")
    }

    open func mainContextFetchResultController(for _: AnyObject, sectionNameKeyPath _: String?, cacheName _: String?) throws -> AnyObject {
        fatalError("should be overriden")
    }

    open func perform(block: @escaping ObjectContextCompletion) {
        workingContext().execute(appContext: appContext) { context in
            block(context)
        }
    }

    open func perform(objectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion) {
        objectContext.execute(appContext: appContext) { context in
            block(context)
        }
    }

    public func stash(block: @escaping ThrowableCompletion) {
        stash(objectContext: workingContext(), completion: block)
    }

    public func stash(objectContext: ManagedObjectContextProtocol?, completion: @escaping ThrowableCompletion) {
        guard let objectContext = objectContext else {
            completion(DataStoreError.contextNotDefined)
            return
        }

        objectContext.save(appContext: appContext) { error in
            completion(error)
        }
    }

    public func fetchLocal(byModelClass modelClass: PrimaryKeypathProtocol.Type, nspredicate: NSPredicate?, completion: @escaping FetchResultCompletion) {
        let localCallback: FetchResultCompletion = { fetchResult, error in
            self.workingContext().execute(appContext: self.appContext) { managedObjectContext in
                let fetchResultForContext = fetchResult?.makeDublicate(inContext: managedObjectContext)
                completion(fetchResultForContext, error)
            }
        }

        //
        appContext.logInspector?.logEvent(EventLocalFetch("\(String(describing: modelClass)) - \(String(describing: nspredicate))"), sender: self)

        guard isClassValid(modelClass) else {
            let error = DataStoreError.notManagedObjectType(modelClass)
            let result = emptyFetchResult()
            completion(result, error)
            return
        }

        let managedObjectContext = newPrivateContext()
        perform(objectContext: managedObjectContext) {[weak self] managedObjectContext in
            guard let self = self else {
                return
            }
            guard let managedObject = managedObjectContext.findOrCreateObject(forType: modelClass, predicate: nspredicate) else {
                self.appContext.logInspector?.logEvent(EventError(DataStoreError.objectNotCreated(modelClass), details: self), sender: nil)
                return
            }
            self.stash(objectContext: managedObjectContext) { error in
                let fetchResult = FetchResult(objectContext: managedObjectContext, objectID: managedObject.managedObjectID, predicate: nspredicate, fetchStatus: managedObject.fetchStatus)
                localCallback(fetchResult, error)
            }
        }
    }

    public func fetchLocal(objectContext: ManagedObjectContextProtocol, byModelClass Clazz: AnyObject, contextPredicate: ContextPredicateProtocol, completion: @escaping FetchResultCompletion) {
        //
        appContext.logInspector?.logEvent(EventLocalFetch("\(String(describing: Clazz)) - \(String(describing: contextPredicate))"), sender: self)

        guard isClassValid(Clazz) else {
            let error = DataStoreError.clazzIsNotSupportable(String(describing: Clazz))
            appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            let result = emptyFetchResult()
            completion(result, error)
            return
        }

        guard let predicate = contextPredicate.nspredicate(operator: .and) else {
            let error = DataStoreError.noKeysDefinedForClass(String(describing: Clazz))
            let fetchResult = FetchResult(objectContext: objectContext, objectID: nil, predicate: nil, fetchStatus: .fetched)
            completion(fetchResult, error)
            return
        }

        perform(objectContext: objectContext) {[weak self] managedObjectContext in
            if let managedObject = managedObjectContext.findOrCreateObject(forType: Clazz, predicate: predicate) {
                let fetchResult = FetchResult(objectContext: managedObjectContext, objectID: managedObject.managedObjectID, predicate: predicate, fetchStatus: managedObject.fetchStatus)
                completion(fetchResult, nil)
            } else {
                let result = self?.emptyFetchResult()
                completion(result, nil)
            }
        }
    }
}

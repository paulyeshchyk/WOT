//
//  CoreDataStore.swift
//  WOT-iOS
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import CoreData
import ContextSDK

@objc
open class DataStore: NSObject {
    
    private enum DataStoreError: Error, CustomStringConvertible {
        case clazzIsNotSupportable(String)
        case contextNotSaved
        case objectNotCreated(AnyClass)
        public var description: String {
            switch self {
            case .contextNotSaved: return "\(type(of: self)): Context is not saved"
            case .objectNotCreated(let clazz): return "\(type(of: self)): Object is not created:[\(String(describing: clazz))]"
            case .clazzIsNotSupportable(let clazz): return "\(type(of: self)): Class is not supported by mapper:[\(String(describing: clazz))]"
            }
        }
    }

    public typealias Context = LogInspectorContainerProtocol

    // MARK: - Open

    open var sqliteURL: URL? { fatalError("should be overriden") }
    open var modelURL: URL? { fatalError("should be overriden") }
    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { fatalError("should be overriden") }

    private let context: Context

    required public init(context: Context) {
        self.context = context
        super.init()
    }

    // MARK: - Private

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let sqliteURL = self.sqliteURL else {
            abort()
        }

        guard let model = self.managedObjectModel else {
            abort()
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: nil)
        } catch {
            abort()
        }
        return coordinator
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.name = "Main"
        managedObjectContext.parent = self.masterContext
        return managedObjectContext
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.name = "Master"
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()

    @objc private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    private func perform(inManagedObjectContext: NSManagedObjectContext, block: @escaping ObjectContextCompletion) {
        let privateBlock: ObjectContextCompletion = { context in
            block(context)
        }
        inManagedObjectContext.perform { privateBlock(inManagedObjectContext) }
    }
}

extension DataStore {

    // MARK: - Merge Contexts

    private func mergeChanges(notification: Notification, toContext: NSManagedObjectContext) {
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] {
            mergeObjects(updatedObjects, toContext: toContext, fromNotification: notification)
        }
        if let updatedObject = notification.userInfo?[NSUpdatedObjectsKey] as? NSManagedObject {
            mergeObjects([updatedObject], toContext: toContext, fromNotification: notification)
        }

        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? [NSManagedObject] {
            mergeObjects(insertedObjects, toContext: toContext, fromNotification: notification)
        }

        if let insertedObject = notification.userInfo?[NSInsertedObjectsKey] as? NSManagedObject {
            mergeObjects([insertedObject], toContext: toContext, fromNotification: notification)
        }
    }

    private func mergeObjects(_ objects: [NSManagedObject], toContext: NSManagedObjectContext, fromNotification: Notification) {
        context.logInspector?.logEvent(EventCDMerge(), sender: self)
        var updatedObjectsInCurrentContext = Set<NSManagedObject>()

        objects.forEach { updatedObject in
            let objectFromContext = toContext.object(with: updatedObject.objectID)
            objectFromContext.willAccessValue(forKey: nil)
            updatedObjectsInCurrentContext.insert(objectFromContext)
        }

        toContext.mergeChanges(fromContextDidSave: fromNotification)
        let setOfUpdatedObjects = updatedObjectsInCurrentContext.intersection(toContext.updatedObjects)
        setOfUpdatedObjects.forEach { obj in
            toContext.refresh(obj, mergeChanges: true)
        }

        if toContext.hasChanges {
            do {
                try toContext.save()
            } catch {
                context.logInspector?.logEvent(EventError(DataStoreError.contextNotSaved, details: self), sender: nil)
            }
        }
        toContext.processPendingChanges()
    }
}

public enum WOTFetcherError: Error, CustomStringConvertible {
    case requestsNotParsed
    case noKeysDefinedForClass(String)
    case notManagedObjectType(PrimaryKeypathProtocol.Type)

    public var description: String {
        switch self {
        case .noKeysDefinedForClass(let clazz): return "[\(type(of: self))]: No keys defined for:[\(String(describing: clazz))]"
        case .requestsNotParsed: return "[\(type(of: self))]: request is not parsed"
        case .notManagedObjectType(let clazz): return "[\(type(of: self))]: Not ManagedObjectType:[\(String(describing: clazz))]"
        }
    }
}

// MARK: - WOTDataStoreProtocol

extension DataStore {
    public func stash(block: @escaping ThrowableCompletion) {
        let MAINCONTEXT = self.workingContext()
        stash(objectContext: MAINCONTEXT, block: block)
    }

    public func fetchLocal(byModelClass modelClass: PrimaryKeypathProtocol.Type, requestPredicate: NSPredicate?, completion: @escaping FetchResultCompletion) {
        let localCallback: FetchResultCompletion = { fetchResult, error in
            guard let MAINCONTEXT = self.workingContext() as? NSManagedObjectContext else {
                assertionFailure("MAINCONTEXT is not NSManagedObjectContext")
                return
            }

            MAINCONTEXT.perform {
                let fetchResultForContext = fetchResult.dublicate()
                fetchResultForContext.objectContext = MAINCONTEXT
                completion(fetchResultForContext, error)
            }
        }

        guard let Clazz = modelClass as? NSManagedObject.Type else {
            let error = WOTFetcherError.notManagedObjectType(modelClass)
            completion(EmptyFetchResult(), error)
            return
        }

        let managedObjectContext = newPrivateContext()
        perform(objectContext: managedObjectContext) { context in
            guard let managedObject = context.findOrCreateObject(forType: Clazz, predicate: requestPredicate) as? NSManagedObject else {
                self.context.logInspector?.logEvent(EventError(DataStoreError.objectNotCreated(Clazz), details: self), sender: nil)
                return
            }
            let managedObjectID = managedObject.objectID
            let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .fetched
            self.stash(objectContext: context) { error in
                let fetchResult = FetchResult(objectContext: context, objectID: managedObjectID, predicate: requestPredicate, fetchStatus: fetchStatus)
                localCallback(fetchResult, error)
            }
        }
    }
}

// MARK: - WOTCoredataStoreProtocol

extension DataStore: DataStoreProtocol {

    public func stash(objectContext: ManagedObjectContextProtocol?, block: @escaping ThrowableCompletion) {
        
        guard let managedObjectContext = objectContext as? NSManagedObjectContext else {
            assertionFailure("managedObjectContext is not defined")
            return
        }
        
        let initialDate = Date()

        context.logInspector?.logEvent(EventCDStashStart(context: managedObjectContext), sender: self)
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.context.logInspector?.logEvent(EventCDStashEnded(context: managedObjectContext, initiatedIn: initialDate), sender: self)
        }

        managedObjectContext.saveRecursively(customBlock)
        context.logInspector?.logEvent(EventTimeMeasure("Context save start", uuid: uuid), sender: self)
    }

    public func fetchLocal(objectContext: ManagedObjectContextProtocol, byModelClass Clazz: AnyObject, predicate: ContextPredicate, completion: @escaping FetchResultCompletion) {
        guard let ManagedObjectClass = Clazz as? NSManagedObject.Type else {
            let error = DataStoreError.clazzIsNotSupportable(String(describing: Clazz))
            context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            completion(EmptyFetchResult(), error)
            return
        }

        context.logInspector?.logEvent(EventLocalFetch("\(String(describing: ManagedObjectClass)) - \(String(describing: predicate))"), sender: self)

        guard let predicate = predicate.compoundPredicate(.and) else {
            let error = WOTFetcherError.noKeysDefinedForClass(String(describing: ManagedObjectClass))
            let fetchResult = FetchResult(objectContext: objectContext, objectID: nil, predicate: nil, fetchStatus: .fetched)
            completion(fetchResult, error)
            return
        }

        self.perform(objectContext: objectContext) { context in
            if let managedObject = context.findOrCreateObject(forType: ManagedObjectClass, predicate: predicate) {
                let managedObjectID = managedObject.objectID
                let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .fetched
                let fetchResult = FetchResult(objectContext: context, objectID: managedObjectID, predicate: predicate, fetchStatus: fetchStatus)
                completion(fetchResult, nil)
            } else {
                completion(EmptyFetchResult(), nil)
            }
        }
    }
    // MARK: - WOTCoredataStoreProtocol

    @objc public func newPrivateContext() -> ManagedObjectContextProtocol {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.name = "Private"
        managedObjectContext.parent = mainContext
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }

    @objc public func workingContext() -> ManagedObjectContextProtocol {
        return mainContext
    }

    @objc
    public func perform(objectContext: ManagedObjectContextProtocol, block: @escaping ObjectContextCompletion) {
        guard let managedObjectContext = objectContext as? NSManagedObjectContext else {
            assertionFailure("context is not NSManagedObjectContext")
            return
        }
        perform(inManagedObjectContext: managedObjectContext, block: block)
    }

    @objc
    public func fetchResultController(for request: AnyObject, andContext: ManagedObjectContextProtocol) -> AnyObject {
        guard let context = andContext as? NSManagedObjectContext else {
            fatalError("context is notNSManagedObjectContext")
        }
        
        guard let request = request as? NSFetchRequest<NSFetchRequestResult> else {
            fatalError("request is not NSFetchRequest")
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

    @objc
    public func mainContextFetchResultController(for request: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) -> AnyObject {
        guard let request = request as? NSFetchRequest<NSFetchRequestResult> else {
            fatalError("request is not NSFetchRequest")
        }
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}

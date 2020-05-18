//
//  WOTCoreDataStore.swift
//  WOT-iOS
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import CoreData
import Foundation

@objc
open class WOTCoreDataStore: NSObject {
    // MARK: - Open

    open var sqliteURL: URL? { fatalError("should be overriden") }
    open var modelURL: URL? { fatalError("should be overriden") }
    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { fatalError("should be overriden") }

    private let logInspector: LogInspectorProtocol

    required public init(logInspector: LogInspectorProtocol) {
        self.logInspector = logInspector
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

    private func perform(inManagedObjectContext: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        let privateBlock: NSManagedObjectContextCompletion = { context in
            block(context)
        }
        inManagedObjectContext.perform { privateBlock(inManagedObjectContext) }
    }
}

extension WOTCoreDataStore {
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
        logEvent(EventCDMerge())
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
            } catch {}
        }
        toContext.processPendingChanges()
    }
}

public enum WOTFetcherError: Error, CustomDebugStringConvertible {
    case requestsNotParsed
    case noKeysDefinedForClass(String)
    case notManagedObjectType(PrimaryKeypathProtocol.Type)

    public var debugDescription: String {
        switch self {
        case .noKeysDefinedForClass(let clazz): return "No keys defined for:[\(String(describing: clazz))]"
        case .requestsNotParsed: return "request is not parsed"
        case .notManagedObjectType(let clazz): return "Not ManagedObjectType:[\(String(describing: clazz))]"
        }
    }
}

// MARK: - WOTDataStoreProtocol

extension WOTCoreDataStore {
    public func stash(block: @escaping ThrowableCompletion) {
        let MAINCONTEXT = self.workingContext()
        stash(managedObjectContext: MAINCONTEXT, block: block)
    }

    public func fetchLocal(byModelClass modelClass: PrimaryKeypathProtocol.Type, requestPredicate: NSPredicate?, completion: @escaping FetchResultErrorCompletion) {
        let localCallback: FetchResultErrorCompletion = { fetchResult, error in
            let MAINCONTEXT = self.workingContext()

            MAINCONTEXT.perform {
                let fetchResultForContext = fetchResult.dublicate()
                fetchResultForContext.managedObjectContext = MAINCONTEXT
                completion(fetchResultForContext, error)
            }
        }

        guard let Clazz = modelClass as? NSManagedObject.Type else {
            let error = WOTFetcherError.notManagedObjectType(modelClass)
            completion(EmptyFetchResult(), error)
            return
        }

        let managedObjectContext = newPrivateContext()
        perform(managedObjectContext: managedObjectContext) { context in
            do {
                guard let managedObject = try context.findOrCreateObject(forType: Clazz, predicate: requestPredicate) else {
                    self.logEvent(EventError(WOTCoreDataStoreError.objectNotCreated(Clazz), details: self), sender: nil)
                    return
                }
                let managedObjectID = managedObject.objectID
                let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .fetched
                self.stash(managedObjectContext: context) { error in
                    let fetchResult = FetchResult(managedObjectContext: context, objectID: managedObjectID, predicate: requestPredicate, fetchStatus: fetchStatus)
                    localCallback(fetchResult, error)
                }
            } catch {
                self.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }

}

// MARK: - WOTCoredataStoreProtocol

extension WOTCoreDataStore: WOTCoredataStoreProtocol {

    public func stash(managedObjectContext: NSManagedObjectContext, block: @escaping ThrowableCompletion) {
        let initialDate = Date()

        logEvent(EventCDStashStart(context: managedObjectContext), sender: self)
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.logEvent(EventCDStashEnded(context: managedObjectContext, initiatedIn: initialDate), sender: self)
        }

        managedObjectContext.saveRecursively(customBlock)
        logEvent(EventTimeMeasure("Context save start", uuid: uuid))
    }

    public func fetchLocal(managedObjectContext: NSManagedObjectContext, byModelClass modelClass: NSManagedObject.Type, requestPredicate: RequestPredicate, completion: @escaping FetchResultErrorCompletion) {
        logInspector.logEvent(EventLocalFetch("\(String(describing: modelClass)) - \(String(describing: requestPredicate))"), sender: self)

        guard let predicate = requestPredicate.compoundPredicate(.and) else {
            let error = WOTFetcherError.noKeysDefinedForClass(String(describing: modelClass))
            let fetchResult = FetchResult(managedObjectContext: managedObjectContext, objectID: nil, predicate: nil, fetchStatus: .fetched)
            completion(fetchResult, error)
            return
        }

        self.perform(managedObjectContext: managedObjectContext) { context in
            do {
                if let managedObject = try context.findOrCreateObject(forType: modelClass, predicate: predicate) {
                    let managedObjectID = managedObject.objectID
                    let fetchStatus: FetchStatus = managedObject.isInserted ? .inserted : .fetched
                    let fetchResult = FetchResult(managedObjectContext: context, objectID: managedObjectID, predicate: predicate, fetchStatus: fetchStatus)
                    completion(fetchResult, nil)
                }
            } catch {
                completion(EmptyFetchResult(), error)
            }
        }
    }
    // MARK: - WOTCoredataStoreProtocol

    @objc public func newPrivateContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.name = "Private"
        managedObjectContext.parent = mainContext
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }

    @objc public func workingContext() -> NSManagedObjectContext {
        return mainContext
    }

    @objc
    public func perform(managedObjectContext: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        perform(inManagedObjectContext: managedObjectContext, block: block)
    }

    @objc
    public func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: andContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    @objc
    public func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}

// MARK: - LogInspectorProtocol -

extension WOTCoreDataStore {
    public func logEvent(_ event: LogEventProtocol?, sender: Any?) {
        logInspector.logEvent(event, sender: sender)
    }

    public func logEvent(_ event: LogEventProtocol?) {
        logInspector.logEvent(event)
    }
}

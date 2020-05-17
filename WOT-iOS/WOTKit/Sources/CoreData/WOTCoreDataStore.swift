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

    public var logInspector: LogInspectorProtocol

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
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.name = "Main"
        context.parent = self.masterContext
        return context
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Master"
        context.undoManager = nil
        return context
    }()

    @objc private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    private func perform(inContext: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        let privateBlock: NSManagedObjectContextCompletion = { context in
            block(context)
        }
        inContext.perform { privateBlock(inContext) }
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

// MARK: - WOTCoredataStoreProtocol

extension WOTCoreDataStore: WOTCoredataStoreProtocol {
    // MARK: - WOTDataStoreProtocol

    public func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion) {
        let initialDate = Date()

        logEvent(EventCDStashStart(context: context), sender: self)
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.logEvent(EventCDStashEnded(context: context, initiatedIn: initialDate), sender: self)
        }

        context.saveRecursively(customBlock)
        logEvent(EventTimeMeasure("Context save start", uuid: uuid))
    }

    public func findOrCreateObject(by clazz: NSManagedObject.Type, andPredicate predicate: NSPredicate?, visibleInContext: NSManagedObjectContext, completion: @escaping FetchResultErrorCompletion) {
        let localCallback: FetchResultErrorCompletion = { fetchResult, error in
            visibleInContext.perform {
                let fetchResultForContext = fetchResult.dublicate()
                fetchResultForContext.context = visibleInContext
                completion(fetchResultForContext, error)
            }
        }

        let context = newPrivateContext()
        perform(context: context) { context in
            do {
                guard let managedObject = try context.findOrCreateObject(forType: clazz, predicate: predicate) else {
                    self.logEvent(EventError(WOTCoreDataStoreError.objectNotCreated(clazz), details: self), sender: nil)
                    return
                }
                let managedObjectID = managedObject.objectID
                self.stash(context: context) { error in
                    let fetchResult = FetchResult(context: context, objectID: managedObjectID, predicate: predicate, fetchStatus: .none)
                    localCallback(fetchResult, error)
                }
            } catch {
                self.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }

    // MARK: - WOTCoredataStoreProtocol

    @objc public func newPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.name = "Private"
        context.parent = mainContext
        context.undoManager = nil
        return context
    }

    @objc public func workingContext() -> NSManagedObjectContext {
        return mainContext
    }

    @objc
    public func perform(context: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        perform(inContext: context, block: block)
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

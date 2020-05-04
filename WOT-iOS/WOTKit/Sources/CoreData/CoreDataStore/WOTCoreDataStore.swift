//
//  WOTCoreDataStore.swift
//  WOT-iOS
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

@objc
open class WOTCoreDataStore: NSObject, WOTCoredataStoreProtocol {
    // MARK: - WOTProviderProtocol -

    @objc
    public var appManager: WOTAppManagerProtocol?

    public func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion ) {
        let initialDate = Date()
        self.appManager?.logInspector?.logEvent(EventCDStashStart(context: context), sender: self)
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.appManager?.logInspector?.logEvent(EventCDStashEnded(context: context, initiatedIn: initialDate), sender: self)
        }

        context.saveRecursively(customBlock)
        appManager?.logInspector?.logEvent(EventTimeMeasure("Context save start", uuid: uuid))
    }

    public func findOrCreateObject(by clazz: NSManagedObject.Type, andPredicate predicate: NSPredicate?, visibleInContext: NSManagedObjectContext, callback: @escaping FetchResultErrorCompletion ) {
        let privateCallback: FetchResultErrorCompletion = { fetchResult, error in
            visibleInContext.perform {
                let fetchResultForContext = fetchResult.dublicate()
                fetchResultForContext.context = visibleInContext
                callback(fetchResultForContext, error)
            }
        }

        let context = newPrivateContext()
        perform(context: context) { context in
            do {
                guard let managedObject = try context.findOrCreateObject(forType: clazz, predicate: predicate) else {
                    self.appManager?.logInspector?.logEvent(EventError(message: "Object not created:[\(String(describing: clazz))]"), sender: nil)
                    return
                }
                let managedObjectID = managedObject.objectID
                self.stash(context: context) { (error) in
                    let fetchResult = FetchResult(context: context, objectID: managedObjectID, predicate: predicate, fetchStatus: .none, error: error)
                    privateCallback(fetchResult, error)
                }
            } catch let error {
                self.appManager?.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }

    // MARK: - WOTCoredataProviderProtocol -

    open var modelURL: URL? { return nil }
    open var sqliteURL: URL? { return nil }
    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { return nil }

    @objc lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let sqliteURL = self.sqliteURL else {
            abort()
        }

        guard let model = self.managedObjectModel else {
            abort()
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: nil)
        } catch let error {
            abort()
        }
        return coordinator
    }()

    @objc public func newPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.name = "Private"
        context.parent = self.mainContext
        context.undoManager = nil

        #warning("check notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataStore.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }

    @objc public lazy var mainContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.name = "Main"
        context.parent = self.masterContext
        return context
    }()

    @objc private lazy var masterContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Master"
        context.undoManager = nil

        #warning("check notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataStore.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }()

    @objc
    public func perform(context: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        perform(inContext: context, block: block)
    }

    @objc
    public func performMain(_ block: @escaping NSManagedObjectContextCompletion) {
        perform(inContext: mainContext, block: block)
    }

    @objc
    public func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: andContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    @objc
    public func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    public func executeRequest(by predicate: NSPredicate, concurency: WOTExecuteConcurency) {}

    // MARK: - Private -
    @objc lazy private var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

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
        appManager?.logInspector?.logEvent(EventCDMerge())
        var updatedObjectsInCurrentContext = Set<NSManagedObject>()

        objects.forEach { (updatedObject) in
            let objectFromContext = toContext.object(with: updatedObject.objectID)
            objectFromContext.willAccessValue(forKey: nil)
            updatedObjectsInCurrentContext.insert(objectFromContext)
        }

        toContext.mergeChanges(fromContextDidSave: fromNotification)
        let setOfUpdatedObjects = updatedObjectsInCurrentContext.intersection(toContext.updatedObjects)
        setOfUpdatedObjects.forEach { (obj) in
            toContext.refresh(obj, mergeChanges: true)
        }

        if toContext.hasChanges {
            do {
                try toContext.save()
            } catch {}
        }
        toContext.processPendingChanges()
    }

    private func perform(inContext: NSManagedObjectContext, block: @escaping NSManagedObjectContextCompletion) {
        let privateBlock: NSManagedObjectContextCompletion = { context in
            block(context)
        }
        inContext.perform { privateBlock(inContext) }
    }

    private func workContextDidSave(notification: Notification) {
        self.masterContext.performAndWait {
            self.mergeChanges(notification: notification, toContext: self.masterContext)
        }
    }

    #warning("check notifications")
    @objc
    private func mainContextDidSave(notification: Notification) {
//        self.mainContext.perform {
//            self.mergeChanges(notification: notification, toContext: self.masterContext)
//        }
    }
}

extension WOTCoreDataStore: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

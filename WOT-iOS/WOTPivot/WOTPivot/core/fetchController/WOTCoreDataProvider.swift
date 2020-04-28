//
//  WOTCoreDataProvider.swift
//  WOT-iOS
//
//  Created on 8/22/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

@objc
open class WOTCoreDataProvider: NSObject, WOTCoredataProviderProtocol {
    // MARK: - WOTProviderProtocol -

    @objc
    public var appManager: WOTAppManagerProtocol?

    public func stash(context: NSManagedObjectContext, block: @escaping ThrowableCompletion ) {
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.appManager?.logInspector?.log(TIMEMeasureLog("Context save end", uuid: uuid))
        }

        context.saveRecursively(customBlock)
        appManager?.logInspector?.log(TIMEMeasureLog("Context save start", uuid: uuid))
    }

    public func findOrCreateObject(by clazz: AnyClass, andPredicate predicate: NSPredicate?, callback: @escaping ContextAnyObjectErrorCompletion ) {
        let privateCompletion: ContextAnyObjectErrorCompletion = { context, managedObjectID, error in

            self.performMain { (mainContext) in
                callback(mainContext, managedObjectID, error)
            }
        }

        let context = privateContext()
        perform(context: context) { context in
            do {
                let managedObject = try NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context)
                let managedObjectID = managedObject?.objectID
                self.stash(context: context) { (error) in
                    privateCompletion(context, managedObjectID, error)
                }
            } catch let error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: nil)
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

    @objc public func privateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.name = "Private"
        context.parent = self.mainContext
        context.undoManager = nil
        #warning("check notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataProvider.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }

    @objc public lazy var mainContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.name = "Main"
        context.parent = self.masterContext
//        context.mergePolicy = self.masterContext.mergePolicy
        return context
    }()

    @objc private lazy var masterContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        if #available(iOS 10.0, *) {
//            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        } else {
//            print("not iOS 10.0")
//        }
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Master"
        context.undoManager = nil
        #warning("check notifications")

        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataProvider.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
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
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: masterContext, sectionNameKeyPath: nil, cacheName: nil)
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
        appManager?.logInspector?.log(CDMergeLog())
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
        inContext.perform {
            block(inContext)
        }
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

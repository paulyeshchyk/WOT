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

    public func stash(_ block: @escaping ThrowableCompletion ) {
        let uuid = UUID()
        let customBlock: ThrowableCompletion = { error in
            block(error)
            self.appManager?.logInspector?.log(TIMEMeasureLog("Context save end", uuid: uuid))
        }

        appManager?.logInspector?.log(TIMEMeasureLog("Context save start", uuid: uuid))

        guard workManagedObjectContext.hasChanges else {
            customBlock(nil)
            return
        }
        workManagedObjectContext.perform {
            do {
                try self.workManagedObjectContext.save()
                self.mainManagedObjectContext.performAndWait {
                    do {
                        try self.mainManagedObjectContext.save()
                        customBlock(nil)
                    } catch let error {
                        customBlock(error)
                    }
                }
            } catch let error {
                customBlock(error)
            }
        }
    }

    public func findOrCreateObject(by clazz: AnyClass, andPredicate predicate: NSPredicate?, callback: @escaping AnyObjectErrorCompletion ) {
        perform { context in
            do {
                let managedObject = try NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context)
                let error = (managedObject == nil) ? JSONError.parse(message: "\(String(describing: clazz)) not found by predicate:\(predicate?.predicateFormat ?? "<Unknown predicate>")") : nil
                callback(managedObject, error)
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

    @objc public lazy var mainManagedObjectContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.undoManager = nil
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataProvider.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context

    }()

    @objc private lazy var workManagedObjectContext: NSManagedObjectContext  = {
        return mainManagedObjectContext
    }()

    @objc
    public func perform(_ block: @escaping NSManagedObjectContextCompletion) {
        perform(inContext: workManagedObjectContext, block: block)
    }

    @objc
    public func performMain(_ block: @escaping NSManagedObjectContextCompletion) {
        perform(inContext: mainManagedObjectContext, block: block)
    }

    @objc
    public func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: andContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    @objc
    public func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
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
        self.mainManagedObjectContext.performAndWait {
            self.mergeChanges(notification: notification, toContext: self.mainManagedObjectContext)
        }
    }

    @objc
    private func mainContextDidSave(notification: Notification) {
        self.workManagedObjectContext.perform {
            self.mergeChanges(notification: notification, toContext: self.workManagedObjectContext)
        }
    }
}

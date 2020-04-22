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
    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { return nil }

    @objc
    public var appManager: WOTAppManagerProtocol?

    @objc lazy public var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    open var modelURL: URL? { return nil }

    open var sqliteURL: URL? { return nil }

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

    @objc public lazy var workManagedObjectContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        context.parent = self.mainManagedObjectContext
        context.undoManager = nil
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataProvider.workContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }()

    @objc public lazy var mainManagedObjectContext: NSManagedObjectContext  = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.undoManager = nil
        NotificationCenter.default.addObserver(self, selector: #selector(WOTCoreDataProvider.mainContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context

    }()

    @objc private func mainContextDidSave(notification: Notification) {
        self.workManagedObjectContext.perform {
            self.mergeChanges(notification: notification, toContext: self.workManagedObjectContext)
        }
    }

    @objc private func workContextDidSave(notification: Notification) {
        self.mainManagedObjectContext.performAndWait {
            self.mergeChanges(notification: notification, toContext: self.mainManagedObjectContext)
        }
    }

    @objc
    public func findOrCreateObject(by clazz: AnyClass, andPredicate predicate: NSPredicate?, callback: @escaping (NSManagedObject) -> Void ) {
        perform { context in
            guard let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: predicate, context: context) else {
                fatalError("Managed object is not created:\(predicate?.description ?? "<Unknown predicate>")")
            }
            callback(managedObject)
        }
    }

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

    public func executeRequest(by predicate: NSPredicate, concurency: WOTExecuteConcurency) {}

    private func tryToSave(_ context: NSManagedObjectContext, block: @escaping (Error?) -> Void) {
        guard context.hasChanges else {
            block(nil)
            return
        }
        do {
            try context.save()
            block(nil)
        } catch let error {
            block(error)
        }
    }

    private func perform(inContext: NSManagedObjectContext, block: @escaping (NSManagedObjectContext) -> Void) {
        inContext.perform {
            block(inContext)
        }
    }

    @objc
    public func perform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        perform(inContext: workManagedObjectContext, block: block)
    }

    @objc
    public func performMain(_ block: @escaping (NSManagedObjectContext) -> Void) {
        perform(inContext: mainManagedObjectContext, block: block)
    }

    @objc
    public func stash(_ block: @escaping (Error?) -> Void) {
        let uuid = UUID()
        let customBlock: ((Error?) -> Void ) = { error in
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

    @objc
    public func fetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, andContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: andContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    @objc
    public func mainContextFetchResultController(for request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName name: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}

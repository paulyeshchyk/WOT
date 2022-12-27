//
//  CoreDataStore.swift
//  WOTKit
//
//  Created by Paul on 26.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import CoreData

@objc
open class CoreDataStore: DataStore {

    private enum CoreDataStoreError: Error, CustomStringConvertible {
        case contextIsNotNSManagedObjectContext
        case requestIsNotNSFetchRequest
        var description: String {
            switch self {
            case .contextIsNotNSManagedObjectContext: return "context is notNSManagedObjectContext"
            case .requestIsNotNSFetchRequest: return "request is not NSFetchRequest"
            }
        }
    }
    
    open var sqliteURL: URL? { fatalError("should be overriden") }
    open var modelURL: URL? { fatalError("should be overriden") }
    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { fatalError("should be overriden") }

    override public func newPrivateContext() -> ManagedObjectContextProtocol {
        CoreDataStore.privateQueueConcurrencyContext(parent: mainContext)
    }

    override public func workingContext() -> ManagedObjectContextProtocol {
        return mainContext
    }

    override public func fetchResultController(for request: AnyObject, andContext: ManagedObjectContextProtocol) throws -> AnyObject {
        guard let context = andContext as? NSManagedObjectContext else {
            throw CoreDataStoreError.contextIsNotNSManagedObjectContext
        }
        guard let request = request as? NSFetchRequest<NSFetchRequestResult> else {
            throw CoreDataStoreError.requestIsNotNSFetchRequest
        }
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override public func mainContextFetchResultController(for request: AnyObject, sectionNameKeyPath: String?, cacheName name: String?) throws -> AnyObject {
        guard let request = request as? NSFetchRequest<NSFetchRequestResult> else {
            throw CoreDataStoreError.requestIsNotNSFetchRequest
        }
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    override public func isClassValid(_ clazz: AnyObject) -> Bool {
        return (clazz is NSManagedObject.Type) ? true : false
    }
    
    override public func emptyFetchResult() -> FetchResultProtocol {
        return EmptyFetchResult()
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
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
        CoreDataStore.mainQueueConcurrencyContext(parent: self.masterContext)
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        CoreDataStore.masterContext(persistentStoreCoordinator: self.persistentStoreCoordinator)
    }()

    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
}

extension CoreDataStore {
    static func mainQueueConcurrencyContext(parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.name = "Main"
        managedObjectContext.parent = parent
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }
    static func privateQueueConcurrencyContext(parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.name = "Private"
        managedObjectContext.parent = parent
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }
    static func masterContext(persistentStoreCoordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.name = "Master"
        managedObjectContext.undoManager = nil
        return managedObjectContext
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
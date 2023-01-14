//
//  CoreDataStore.swift
//  WOTKit
//
//  Created by Paul on 26.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import CoreData

// MARK: - CoreDataStore

open class CoreDataStore: DataStore {

    open var sqliteURL: URL? { fatalError("has not been implemented") }
    open var modelURL: URL? { fatalError("has not been implemented") }

    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    open var applicationDocumentsDirectoryURL: URL? { fatalError("has not been implemented") }

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let sqliteURL = self.sqliteURL else {
            abort()
        }

        guard let model = self.managedObjectModel else {
            abort()
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch {
            abort()
        }
        return coordinator
    }()

    private lazy var mainContext: NSManagedObjectContext = CoreDataStore.mainQueueConcurrencyContext(parent: self.masterContext)

    private lazy var masterContext: NSManagedObjectContext = CoreDataStore.masterContext(persistentStoreCoordinator: self.persistentStoreCoordinator)

    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()

    // MARK: Public

    @objc
    override public func newPrivateContext() -> ManagedObjectContextProtocol {
        CoreDataStore.privateQueueConcurrencyContext(parent: mainContext)
    }

    @objc
    override public func workingContext() -> ManagedObjectContextProtocol {
        return mainContext
    }

    override public func fetchResultController(fetchRequest: AnyObject, managedObjectContext: ManagedObjectContextProtocol) throws -> AnyObject {
        guard let context = managedObjectContext as? NSManagedObjectContext else {
            throw CoreDataStoreError.contextIsNotNSManagedObjectContext
        }
        guard let request = fetchRequest as? NSFetchRequest<NSFetchRequestResult> else {
            throw CoreDataStoreError.requestIsNotNSFetchRequest
        }

        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

    override public func mainContextFetchResultController(fetchRequest request: AnyObject, sectionNameKeyPath _: String?, cacheName _: String?) throws -> AnyObject {
        guard let request = request as? NSFetchRequest<NSFetchRequestResult> else {
            throw CoreDataStoreError.requestIsNotNSFetchRequest
        }
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    override public func isClassValid(_ clazz: AnyObject) -> Bool {
        return (clazz is NSManagedObject.Type) ? true : false
    }
}

extension CoreDataStore {
    private static func mainQueueConcurrencyContext(parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.name = "Main <\(UUID().MD5)>"
        managedObjectContext.parent = parent
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }

    private static func privateQueueConcurrencyContext(parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.name = "Private <\(UUID().MD5)>"
        managedObjectContext.parent = parent
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }

    private static func masterContext(persistentStoreCoordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.name = "Master <\(UUID().MD5)>"
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }
}

// MARK: - Merge Contexts

extension CoreDataStore {

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

        let uuid = UUID()
        let executionStartTime = Date()
        appContext.logInspector?.log(.performance(name: "mergeStart", message: "operation: \(uuid.MD5), context: \(toContext.name ?? "")"), sender: self)

        if toContext.hasChanges {
            do {
                try toContext.save()
                appContext.logInspector?.log(.performance(name: "mergeEnd", message: "(\(Date().elapsed(from: executionStartTime))s) operation:\(uuid.MD5), context: \(toContext.name ?? "")"), sender: self)
            } catch {
                appContext.logInspector?.log(.error(CoreDataStoreError.contextNotSaved), sender: self)
            }
        }
        toContext.processPendingChanges()
    }
}

// MARK: - CoreDataStoreError

private enum CoreDataStoreError: Error, CustomStringConvertible {
    case contextNotSaved
    case contextIsNotNSManagedObjectContext
    case requestIsNotNSFetchRequest

    var description: String {
        switch self {
        case .contextNotSaved: return "\(type(of: self)): Context is not saved"
        case .contextIsNotNSManagedObjectContext: return "context is notNSManagedObjectContext"
        case .requestIsNotNSFetchRequest: return "request is not NSFetchRequest"
        }
    }
}

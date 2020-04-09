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
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.undoManager = nil
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
        self.mainManagedObjectContext.perform {
            self.mergeChanges(notification: notification, toContext: self.mainManagedObjectContext)
        }
    }

    private func mergeChanges(notification: Notification, toContext: NSManagedObjectContext) {
        guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] else {
            return
        }

        var updatedObjectsInCurrentContext = Set<NSManagedObject>()

        updatedObjects.forEach { (updatedObject) in
            let objectFromContext = toContext.object(with: updatedObject.objectID)
            objectFromContext.willAccessValue(forKey: nil)
            updatedObjectsInCurrentContext.insert(objectFromContext)
        }

        toContext.mergeChanges(fromContextDidSave: notification)
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
}

//
//  WOTCoreDataProvider.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/22/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

@objc
public class WOTCoreDataProvider: NSObject, WOTCoredataProviderProtocol {

    @objc public static let sharedInstance = WOTCoreDataProvider()

    /// The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    private var applicationDocumentsDirectoryURL: URL? {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
    }

    @objc lazy public var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = self.modelURL else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()


    private var modelURL: URL? {
        return Bundle.main.url(forResource: "WOT_iOS", withExtension: "momd")
    }

    private var sqliteURL: URL? {
        guard var result = self.applicationDocumentsDirectoryURL else {
            return nil
        }
        result.appendPathComponent("WOT_iOS.sqlite")
        return result
    }


    @objc lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        guard let sqliteURL = self.sqliteURL else {
            return nil
        }

        guard let model = self.managedObjectModel else {
            return nil
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: nil)
        } catch let error {
            //                // Report any error we got.
            //                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //                dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            //                dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            //                dict[NSUnderlyingErrorKey] = error;
            //                error = [NSError errorWithDomain:@"WOTCOREDATA" code:9999 userInfo:dict];
            abort()
        }
        return coordinator
    }()

    @objc public lazy var workManagedObjectContext: NSManagedObjectContext  = {

        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
//        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context

    }()

    @objc public lazy var mainManagedObjectContext: NSManagedObjectContext  = {

        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        //context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
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
            } catch {

            }
        }
        toContext.processPendingChanges()
    }

    public func executeRequest(by predicate: NSPredicate , concurency: WOTExecuteConcurency) {

    }
}

//
//  NSManagedObjectContext+ObjectContextProtocol.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import CoreData

// MARK: - NSManagedObjectContext + ManagedObjectContextProtocol

extension NSManagedObjectContext: ManagedObjectContextProtocol {
    // MARK: - ManagedObjectContextLookupProtocol

    public func execute(appContext: ManagedObjectContextLookupProtocol.Context, with block: @escaping (ManagedObjectContextProtocol) -> Void) {
        let uuid = UUID()
        let executionStartTime = Date()
        appContext.logInspector?.log(.sqlite(message: "exec start operation: \(uuid.MD5), in: \(String(describing: self))"), sender: self)
        perform {
            block(self)
            appContext.logInspector?.log(.sqlite(message: "exec end (\(Date().elapsed(from: executionStartTime))s) operation: \(uuid.MD5), in: \(String(describing: self))"), sender: self)
        }
    }

    public func object(byID: AnyObject) -> AnyObject? {
        guard let objectID = byID as? NSManagedObjectID else {
            assertionFailure("forObjectID is not NSManagedObject")
            return nil
        }
        return object(with: objectID)
    }

    public func findOrCreateObject(modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol? {
        guard let foundObject = try? lastObject(modelClass: modelClass, predicate: predicate, includeSubentities: false) else {
            return insertNewObject(forType: modelClass)
        }
        return foundObject
    }

    // MARK: - ManagedObjectContextSaveProtocol

    public func hasTheChanges() -> Bool {
        return hasChanges
    }

    public func save(appContext: ManagedObjectContextSaveProtocol.Context, completion block: @escaping ThrowableCompletion) {
        let privateCompletion: ThrowableCompletion = { error in
            self.perform {
                block(error)
            }
        }
        guard hasChanges else {
            privateCompletion(nil)
            return
        }

        let uuid = UUID()
        let initiationDate = Date()
        appContext.logInspector?.log(.sqlite(message: "save-start"), sender: self)
        performAndWait {
            do {
                try self.save()
                appContext.logInspector?.log(.sqlite(message: "save-end"), sender: self)

                if let parent = self.parent {
                    parent.save(appContext: appContext, completion: privateCompletion)
                } else {
                    privateCompletion(nil)
                }
            } catch {
                appContext.logInspector?.log(.sqlite(message: "save-fail"), sender: self)
                privateCompletion(error)
            }
        }
    }

    // MARK: - ManagedObjectContextDeleteProtocol

    func deleteAllObjects() throws {
        if let entitesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName {
            for (_, entityDescription) in entitesByName {
                try deleteAllObjectsForEntity(entity: entityDescription)
            }
        }
    }

    func deleteAllObjectsForEntity(entity anyAntity: AnyObject) throws {
        guard let entity = anyAntity as? NSEntityDescription else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50

        let fetchResults = try fetch(fetchRequest)
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for object in managedObjects {
                delete(object)
            }
        }
    }
}

extension NSManagedObjectContext {
    private func lastObject(modelClass: AnyObject, predicate: NSPredicate?, includeSubentities: Bool) throws -> ManagedObjectProtocol? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: modelClass))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try fetch(request).last as? ManagedObjectProtocol
    }

    private func insertNewObject<T>(forType: AnyObject) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self) as? T
    }

    private func entityDescription(forType: AnyObject) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }
}

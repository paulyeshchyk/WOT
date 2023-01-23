//
//  NSManagedObjectContext+ObjectContextProtocol.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import ContextSDK

extension NSManagedObjectContext: ManagedObjectContextProtocol {
    // MARK: - ManagedObjectContextLookupProtocol

    public func execute(with block: @escaping () -> Void ) {
        perform {
            block()
        }
    }

    public func object(byID: AnyObject) -> AnyObject? {
        guard let objectID = byID as? NSManagedObjectID else {
            assertionFailure("forObjectID is not NSManagedObject")
            return nil
        }
        return object(with: objectID)
    }

    public func findOrCreateObject(forType: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol? {
        guard let foundObject = try? lastObject(forType: forType, predicate: predicate, includeSubentities: false) else {
            return self.insertNewObject(forType: forType)
        }
        return foundObject
    }

    // MARK: - ManagedObjectContextSaveProtocol

    public func hasTheChanges() -> Bool {
        return hasChanges
    }

    public func save(completion block: @escaping ThrowableCompletion) {
        let privateCompletion: ThrowableCompletion = { error in
            self.perform {
                block(error)
            }
        }
        guard hasChanges else {
            privateCompletion(nil)
            return
        }

        performAndWait {
            do {
                try self.save()
                if let parent = self.parent {
                    parent.save(completion: privateCompletion)
                } else {
                    privateCompletion(nil)
                }
            } catch {
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
    private func lastObject(forType: AnyObject, predicate: NSPredicate?, includeSubentities: Bool) throws -> ManagedObjectProtocol? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: forType))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try self.fetch(request).last as? ManagedObjectProtocol
    }

    private func insertNewObject<T>(forType: AnyObject) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self) as? T
    }

    private func entityDescription(forType: AnyObject) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }
}

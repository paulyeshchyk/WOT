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
        appContext.logInspector?.log(.performance(name: "execStart", message: "operation: \(uuid.MD5), context: \(name ?? "")"))
        perform {
            block(self)
            appContext.logInspector?.log(.performance(name: "execEnd", message: "(\(Date().elapsed(from: executionStartTime))s) operation: \(uuid.MD5), context: \(self.name ?? "")"))
        }
    }

    public func object(byID: AnyObject) -> AnyObject? {
        guard let objectID = byID as? NSManagedObjectID else {
            assertionFailure("forObjectID is not NSManagedObject")
            return nil
        }
        return object(with: objectID)
    }

    public func findOrCreateObject(appContext: ManagedObjectContextLookupProtocol.Context, modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol? {
        //
        let predicateDescr: String
        if let predicate = predicate { predicateDescr = String(describing: predicate) } else { predicateDescr = "?" }
        appContext.logInspector?.log(.sqlite(name: "sql-select", message: "\(String(describing: modelClass)) - \(predicateDescr)"))

        if let foundObject = try? lastObject(modelClass: modelClass, predicate: predicate, includeSubentities: false) {
            return foundObject
        } else {
            appContext.logInspector?.log(.sqlite(name: "sql-insert", message: "\(String(describing: modelClass)) - \(predicateDescr)"))
            return insertNewObject(forType: modelClass)
        }
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
        let executionStartTime = Date()
        appContext.logInspector?.log(.performance(name: "saveStart", message: "operation: \(uuid.MD5), context: \(name ?? "")"))
        performAndWait {
            do {
                appContext.logInspector?.log(.sqlite(name: "sql-save", message: "operation: \(uuid.MD5), context: \(name ?? "")"))
                try self.save()
                appContext.logInspector?.log(.performance(name: "saveEnd", message: "(\(Date().elapsed(from: executionStartTime))s) operation:\(uuid.MD5), context: \(name ?? "")"))

                if let parent = self.parent {
                    parent.save(appContext: appContext, completion: privateCompletion)
                } else {
                    privateCompletion(nil)
                }
            } catch {
                appContext.logInspector?.log(.error(error))
                privateCompletion(error)
            }
        }
    }

    // MARK: - ManagedObjectContextDeleteProtocol

    func deleteAllObjects(appContext: ManagedObjectContextSaveProtocol.Context) throws {
        if let entitesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName {
            for (_, entityDescription) in entitesByName {
                try deleteAllObjectsForEntity(appContext: appContext, entity: entityDescription)
            }
        }
    }

    func deleteAllObjectsForEntity(appContext: ManagedObjectContextSaveProtocol.Context, entity: AnyObject) throws {
        guard let entity = entity as? NSEntityDescription else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50

        let fetchResults = try fetch(fetchRequest)
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for object in managedObjects {
                appContext.logInspector?.log(.sqlite(name: "sql-delete", message: "object: \(String(describing: object)), context: \(name ?? "")"))
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

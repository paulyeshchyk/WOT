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
        appContext.logInspector?.log(.sqlite(message: LogMessages.execute_start(uuid, self).description), sender: self)
        perform {
            block(self)
            appContext.logInspector?.log(.sqlite(message: LogMessages.execute_done(executionStartTime, uuid, self).description), sender: self)
        }
    }

    private enum NSManagedObjectContextError: Error {
        case isNotNSManagedObjectID
        case isNotManagedObjectProtocol
    }

    public func object(managedRef: ManagedRefProtocol) -> ManagedObjectProtocol? {
        guard let objectID = managedRef.managedObjectID as? NSManagedObjectID else {
            assertionFailure("forObjectID is not NSManagedObject")
            return nil
        }
        guard let result = object(with: objectID) as? ManagedObjectProtocol else {
            assertionFailure("forObjectID is not ManagedObjectProtocol")
            return nil
        }
        return result
    }

    public func findOrCreateObject(appContext: ManagedObjectContextLookupProtocol.Context, modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol? {
        do {
            guard let foundObject = try lastObject(modelClass: modelClass, predicate: predicate, includeSubentities: false) else {
                appContext.logInspector?.log(.sqlite(message: LogMessages.select_fail(predicate, self).description), sender: self)
                return insertNewObject(appContext: appContext, forType: modelClass)
            }
            appContext.logInspector?.log(.sqlite(message: LogMessages.select_done(predicate, self).description), sender: self)
            return foundObject
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
            return nil
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

        appContext.logInspector?.log(.sqlite(message: LogMessages.save_start(self).description), sender: self)
        performAndWait {
            do {
                try self.save()
                appContext.logInspector?.log(.sqlite(message: LogMessages.save_done(self).description), sender: self)

                if let parent = self.parent {
                    parent.save(appContext: appContext, completion: privateCompletion)
                } else {
                    privateCompletion(nil)
                }
            } catch {
                appContext.logInspector?.log(.sqlite(message: LogMessages.save_fail(self).description), sender: self)
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

    private func insertNewObject<T>(appContext: ManagedObjectContextLookupProtocol.Context, forType: AnyObject) -> T? {
        appContext.logInspector?.log(.sqlite(message: LogMessages.insert_start(forType).description), sender: self)
        let result = NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self) as? T
        let endMessage = (result == nil) ? LogMessages.insert_fail(forType) : LogMessages.insert_done(forType)
        appContext.logInspector?.log(.sqlite(message: endMessage.description), sender: self)
        return result
    }

    private func entityDescription(forType: AnyObject) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }
}

// MARK: - LogMessages

private enum LogMessages: CustomStringConvertible {
    case execute_start(UUID, NSManagedObjectContext)
    case execute_done(Date, UUID, NSManagedObjectContext)
    case select_fail(NSPredicate?, NSManagedObjectContext)
    case select_done(NSPredicate?, NSManagedObjectContext)
    case save_start(NSManagedObjectContext)
    case save_done(NSManagedObjectContext)
    case save_fail(NSManagedObjectContext)
    case insert_start(AnyObject)
    case insert_fail(AnyObject)
    case insert_done(AnyObject)

    var description: String {
        switch self {
        case .execute_start(let uuid, let context): return "exec-start; in: \(context.name ?? "<unknown>"), operation: \(uuid.MD5))"
        case .execute_done(let date, let uuid, let context): return "exec-done; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>"), operation: \(uuid.MD5)"
        case .select_done(let predicate, let context): return "select done; predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .select_fail(let predicate, let context): return "select fail; predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .save_start(let context): return "save-start; in: \(context.name ?? "<unknown>")"
        case .save_done(let context): return "save-done; in: \(context.name ?? "<unknown>")"
        case .save_fail(let context): return "save-fail; in: \(context.name ?? "<unknown>")"
        case .insert_start(let type): return "insert-start; type: \(type)"
        case .insert_fail(let type): return "insert-fail; type: \(type)"
        case .insert_done(let type): return "insert-done; type: \(type)"
        }
    }
}

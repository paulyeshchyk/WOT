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

    public func execute(appContext: ManagedObjectContextProtocol.Context, with block: @escaping ManagedObjectContextProtocol.ContextCompletion) {
        let uuid = UUID()
        let executionStartTime = Date()
        appContext.logInspector?.log(.sqlite(message: LogMessages.perform_start(uuid, self).description), sender: self)
        perform {
            appContext.logInspector?.log(.sqlite(message: LogMessages.perform_done(executionStartTime, uuid, self).description), sender: self)
            block(self)
        }
    }

    public func object(managedRef: ManagedRefProtocol?) throws -> ManagedObjectProtocol {
        guard let objectID = managedRef?.managedObjectID as? NSManagedObjectID else {
            throw NSManagedObjectContextError.invalidObjectID
        }
        return object(with: objectID)
    }

    public func findOrCreateObject(appContext: ManagedObjectContextProtocol.Context, modelClass: AnyObject, predicate: NSPredicate?) -> ManagedObjectProtocol? {
        do {
            appContext.logInspector?.log(.sqlite(message: LogMessages.select_start(predicate, self).description), sender: self)
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

    public func save(appContext: ManagedObjectContextSaveProtocol.Context, completion block: @escaping ThrowableContextCompletion) {
        guard hasTheChanges() else {
            perform { block(self, nil) }
            return
        }

        let executionStartTime = Date()
        appContext.logInspector?.log(.sqlite(message: LogMessages.perform4Save_start(self).description), sender: self)

        _save(appContext: appContext) { error in
            appContext.logInspector?.log(.sqlite(message: LogMessages.perform4Save_done(executionStartTime, self).description), sender: self)
            block(self, error)
        }
    }

    private func _save(appContext: ManagedObjectContextSaveProtocol.Context, completion block: @escaping ThrowableCompletion) {
        let executionStartTime = Date()
        do {
            appContext.logInspector?.log(.sqlite(message: LogMessages.save_start(self).description), sender: self)
            try save()
            appContext.logInspector?.log(.sqlite(message: LogMessages.save_done(executionStartTime, self).description), sender: self)

            parent?.performAndWait {
                parent?.save(appContext: appContext, completion: { _, _ in })
            }
            block(nil)
        } catch {
            block(error)
            appContext.logInspector?.log(.error(error), sender: self)
            appContext.logInspector?.log(.sqlite(message: LogMessages.save_fail(executionStartTime, self).description), sender: self)
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
    //
    typealias Context = LogInspectorContainerProtocol

    private func lastObject(modelClass: AnyObject, predicate: NSPredicate?, includeSubentities: Bool) throws -> ManagedObjectProtocol? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: modelClass))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try fetch(request).last as? ManagedObjectProtocol
    }

    private func insertNewObject<T>(appContext: Context, forType: AnyObject) -> T? {
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

// MARK: - NSManagedObjectContextError

private enum NSManagedObjectContextError: Error, CustomStringConvertible {
    case isNotPrivateQueueConcurrencyType
    case invalidObjectID

    var description: String {
        switch self {
        case .isNotPrivateQueueConcurrencyType: return "Save operation must be performed only in context with concurrency type: PrivateQueueConcurrencyType"
        case .invalidObjectID: return "Provided invalid ObjectID"
        }
    }
}

// MARK: - LogMessages

private enum LogMessages: CustomStringConvertible {
    case perform_start(UUID, NSManagedObjectContext)
    case perform_done(Date, UUID, NSManagedObjectContext)
    case perform4Save_start(NSManagedObjectContext)
    case perform4Save_done(Date, NSManagedObjectContext)
    case select_fail(NSPredicate?, NSManagedObjectContext)
    case select_done(NSPredicate?, NSManagedObjectContext)
    case select_start(NSPredicate?, NSManagedObjectContext)
    case save_start(NSManagedObjectContext)
    case save_done(Date, NSManagedObjectContext)
    case save_fail(Date, NSManagedObjectContext)
    case insert_start(AnyObject)
    case insert_fail(AnyObject)
    case insert_done(AnyObject)

    var description: String {
        switch self {
        case .perform_start(let uuid, let context): return "perform-start; in: \(context.name ?? "<unknown>"), operation: \(uuid.MD5))"
        case .perform_done(let date, let uuid, let context): return "perform-done; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>"), operation: \(uuid.MD5)"
        case .perform4Save_start(let context): return "perform_for_save-start; in: \(context.name ?? "<unknown>"))"
        case .perform4Save_done(let date, let context): return "perform_for_save-done; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>")"
        case .select_start(let predicate, let context): return "select start; predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .select_done(let predicate, let context): return "select done; predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .select_fail(let predicate, let context): return "select fail; predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .save_start(let context): return "save-start; in: \(context.name ?? "<unknown>")"
        case .save_done(let date, let context): return "save-done; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>")"
        case .save_fail(let date, let context): return "save-fail; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>")"
        case .insert_start(let type): return "insert-start; type: \(type)"
        case .insert_fail(let type): return "insert-fail; type: \(type)"
        case .insert_done(let type): return "insert-done; type: \(type)"
        }
    }
}

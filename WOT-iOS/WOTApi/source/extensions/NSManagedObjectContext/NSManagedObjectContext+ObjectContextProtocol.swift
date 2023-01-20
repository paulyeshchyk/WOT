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

    public func execute(appContext: ManagedObjectContextProtocol.Context, with block: @escaping (ManagedObjectContextProtocol) -> Void) {
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

    public func findOrCreateObject(appContext: ManagedObjectContextLookupProtocol.Context, modelClass: AnyObject, predicate: NSPredicate?, completion: @escaping FetchCompletion) {
        do {
            if let foundObject = try lastObject(modelClass: modelClass, predicate: predicate, includeSubentities: false) {
                appContext.logInspector?.log(.sqlite(message: LogMessages.select_done(predicate, self, foundObject).description), sender: self)
                let fetchResult = try foundObject.fetchResult(context: self)
                completion(fetchResult, nil)
                return
            }
            appContext.logInspector?.log(.error(LogMessages.select_fail(modelClass, predicate, self).description), sender: self)
            insertAndSave(appContext: appContext, modelClass: modelClass, completion: completion)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
            completion(nil, error)
        }
    }

    private func insertAndSave(appContext: Context, modelClass: AnyObject, completion: @escaping FetchCompletion) {
        do {
            let insertedObject = insertNewObject(appContext: appContext, forType: modelClass)

            try save()

            let fetchResult = try insertedObject.fetchResult(context: self)

            completion(fetchResult, nil)

        } catch {
            completion(nil, error)
        }
    }

    // MARK: - ManagedObjectContextSaveProtocol

    public func hasTheChanges() -> Bool {
        return hasChanges
    }

    public func save(appContext: ManagedObjectContextSaveProtocol.Context, completion block: @escaping ThrowableCompletion) {
        guard hasChanges else {
            perform { block(nil) }
            return
        }

        guard concurrencyType == .privateQueueConcurrencyType else {
            perform {
                block(NSManagedObjectContextError.isNotPrivateQueueConcurrencyType)
            }
            return
        }

        let executionStartTime = Date()
        appContext.logInspector?.log(.sqlite(message: LogMessages.perform4Save_start(self).description), sender: self)

        performAndWait {
            self._save(appContext: appContext) { error in
                appContext.logInspector?.log(.sqlite(message: LogMessages.perform4Save_done(executionStartTime, self).description), sender: self)
                block(error)
            }
        }
    }

    private func _save(appContext: ManagedObjectContextSaveProtocol.Context, completion block: @escaping ThrowableCompletion) {
        let executionStartTime = Date()
        do {
            appContext.logInspector?.log(.sqlite(message: LogMessages.save_start(self).description), sender: self)
            try save()
            appContext.logInspector?.log(.sqlite(message: LogMessages.save_done(executionStartTime, self).description), sender: self)

            if let parent = parent {
                parent.save(appContext: appContext, completion: block)
            } else {
                block(nil)
            }
        } catch {
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
        guard let nspredicate = predicate else {
            assertionFailure("no predicate")
            return nil
        }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: modelClass))
        request.fetchLimit = 1
        request.predicate = nspredicate
        request.includesSubentities = includeSubentities
        return try fetch(request).last as? ManagedObjectProtocol
    }

    private func insertNewObject(appContext: Context, forType: AnyObject) -> NSManagedObject {
        appContext.logInspector?.log(.sqlite(message: LogMessages.insert_start(forType).description), sender: self)
        let result = NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self)
        appContext.logInspector?.log(.sqlite(message: LogMessages.insert_done(forType).description), sender: self)
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
    case select_fail(AnyObject, NSPredicate?, NSManagedObjectContext)
    case select_done(NSPredicate?, NSManagedObjectContext, ManagedObjectProtocol?)
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
        case .select_done(let predicate, let context, let object): return "select done; found [\(String(describing: object, orValue: "<NULL>"))] by predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .select_fail(let clazz, let predicate, let context): return "select fail; entity: \(type(of: clazz)), predicate: \(String(describing: predicate, orValue: "<NULL>")); in: \(context.name ?? "<unknown>")"
        case .save_start(let context): return "save-start; in: \(context.name ?? "<unknown>")"
        case .save_done(let date, let context): return "save-done; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>")"
        case .save_fail(let date, let context): return "save-fail; (\(Date().elapsed(from: date))s) in: \(context.name ?? "<unknown>")"
        case .insert_start(let type): return "insert-start; type: \(type)"
        case .insert_fail(let type): return "insert-fail; type: \(type)"
        case .insert_done(let type): return "insert-done; type: \(type)"
        }
    }
}

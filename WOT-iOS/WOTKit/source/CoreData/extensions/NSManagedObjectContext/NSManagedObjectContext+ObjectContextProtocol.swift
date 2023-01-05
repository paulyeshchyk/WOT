//
//  NSManagedObjectContext+ObjectContextProtocol.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import CoreData

// MARK: - KitNSManagedObjectContext + ManagedObjectContextProtocol

extension KitNSManagedObjectContext: ManagedObjectContextProtocol {
    // MARK: - ManagedObjectContextLookupProtocol

    public func execute(with block: @escaping (ManagedObjectContextProtocol) -> Void) {
        let uuid = UUID()
        let executionStartTime = Date()
        appContext?.logInspector?.log(.sqlite(message: "exec start operation: \(uuid.MD5), in: \(String(describing: self))"))
        perform {
            block(self)
            self.appContext?.logInspector?.log(.sqlite(message: "exec end (\(Date().elapsed(from: executionStartTime))s) operation: \(uuid.MD5), in: \(String(describing: self))"))
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
        //
        if let foundObject = try? lastObject(modelClass: modelClass, predicate: predicate, includeSubentities: false) {
            return foundObject
        } else {
            return insertNewObject(forType: modelClass)
        }
    }

    // MARK: - ManagedObjectContextSaveProtocol

    public func hasTheChanges() -> Bool {
        return hasChanges
    }

    private func saveSelfAndParents(completion: @escaping ThrowableCompletion) throws {
        appContext?.logInspector?.log(.sqlite(message: "saveParentContexts save started in: \(String(describing: self))"))
        try save()
        appContext?.logInspector?.log(.sqlite(message: "saveParentContexts save finished in: \(String(describing: self))"))
        try saveParentContexts(completion: completion)
    }

    private func saveParentContexts(completion: @escaping ThrowableCompletion) throws {
        appContext?.logInspector?.log(.sqlite(message: "saveParentContexts started in: \(String(describing: self))"))
        guard let parentContext = parent as? KitNSManagedObjectContext else {
            appContext?.logInspector?.log(.sqlite(message: "saveParentContexts no parents in: \(String(describing: self))"))
            completion(nil)
            appContext?.logInspector?.log(.sqlite(message: "saveParentContexts finished in: \(String(describing: self))"))
            return
        }
        guard parentContext.hasChanges else {
            appContext?.logInspector?.log(.sqlite(message: "saveParentContexts no changes in: \(String(describing: self))"))
            completion(nil)
            appContext?.logInspector?.log(.sqlite(message: "saveParentContexts finished in: \(String(describing: self))"))
            return
        }

        appContext?.logInspector?.log(.sqlite(message: "saveParentContexts will performandwait in: \(String(describing: self))"))
        try parentContext.performAndWa1t {
            try parentContext.saveSelfAndParents(completion: completion)
        }
    }

    public func stash(completion block: @escaping ThrowableCompletion) {
        appContext?.logInspector?.log(.sqlite(message: "saveData in: \(String(describing: self))"))
        guard hasChanges else {
            appContext?.logInspector?.log(.sqlite(message: "no changes in: \(String(describing: self))"))
            block(nil)
            return
        }

        appContext?.logInspector?.log(.sqlite(message: "saveData will perform save in: \(String(describing: self))"))
        perform {
            do {
                try self.saveSelfAndParents(completion: block)
            } catch {
                self.appContext?.logInspector?.log(.sqlite(message: "save failed in: \(String(describing: self))"))
                block(error)
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

    func deleteAllObjectsForEntity(entity: AnyObject) throws {
        guard let entity = entity as? NSEntityDescription else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50

        let fetchResults = try fetch(fetchRequest)
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for object in managedObjects {
                appContext?.logInspector?.log(.sqlite(message: "delete object: \(String(describing: object)), in: \(String(describing: self))"))
                delete(object)
            }
        }
    }
}

extension NSManagedObjectContext {
    func lastObject(modelClass: AnyObject, predicate: NSPredicate?, includeSubentities: Bool) throws -> ManagedObjectProtocol? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: modelClass))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try fetch(request).last as? ManagedObjectProtocol
    }

    func insertNewObject<T>(forType: AnyObject) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self) as? T
    }

    func entityDescription(forType: AnyObject) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }
}

extension NSManagedObjectContext {
    func performAndWa1t<T>(_ block: () throws -> T) rethrows -> T {
        return try _performAndWaitHelper(fn: performAndWait, execute: block, rescue: { throw $0 })
    }

    /// Helper function for convincing the type checker that
    /// the rethrows invariant holds for performAndWait.
    ///
    /// Source: https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249
    private func _performAndWaitHelper<T>(fn: (() -> Void) -> Void,
                                          execute work: () throws -> T,
                                          rescue: ((Error) throws -> (T))) rethrows -> T {
        var result: T?
        var error: Error?
        withoutActuallyEscaping(work) { _work in
            fn {
                do {
                    result = try _work()
                } catch let e {
                    error = e
                }
            }
        }
        if let e = error {
            return try rescue(e)
        } else {
            return result!
        }
    }
}

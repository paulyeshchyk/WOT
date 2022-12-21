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
    public func hasTheChanges() -> Bool {
        return hasChanges
    }
    

    public func object(byID: AnyObject) -> AnyObject? {
        guard let objectID = byID as? NSManagedObjectID else {
            assertionFailure("forObjectID is not NSManagedObject")
            return nil
        }
        return object(with: objectID)
    }

    public func findOrCreateObject(forType: AnyObject, predicate: NSPredicate?) -> AnyObject? {
        guard let foundObject = try? lastObject(forType: forType, predicate: predicate, includeSubentities: false) else {
            return self.insertNewObject(forType: forType)
        }
        return foundObject
    }

    private func lastObject(forType: AnyObject, predicate: NSPredicate?, includeSubentities: Bool) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: forType))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try self.fetch(request).last as? NSManagedObject
    }

    private func insertNewObject<T>(forType: AnyObject) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self) as? T
    }

    private func entityDescription(forType: AnyObject) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }
    
    public func saveContext() {
        do {
            try save()
        } catch {
            print(error)
        }
    }
}

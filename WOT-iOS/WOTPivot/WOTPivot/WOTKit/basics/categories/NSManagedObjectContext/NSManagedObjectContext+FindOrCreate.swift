//
//  NSManagedObjectContext+FindOrCreate.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    public func insertNewObject(forType: NSManagedObject.Type) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: forType), into: self)
    }

    public func entityDescription(forType: NSManagedObject.Type) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: forType), in: self)
    }

    public func findOrCreateObject(forType: NSManagedObject.Type, predicate: NSPredicate?) throws -> NSManagedObject? {
        //
        guard let foundObject = try self.singleObject(forType: forType, predicate: predicate, includeSubentities: false) else {
            return self.insertNewObject(forType: forType)
        }
        return foundObject
    }

    public func singleObject(forType: NSManagedObject.Type, predicate: NSPredicate?, includeSubentities: Bool) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: forType))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        return try self.fetch(request).last as? NSManagedObject
    }
}

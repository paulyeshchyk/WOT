//
//  NSManagedObject+Operations.swift
//  WOTData
//
//  Created on 9/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData
@objc
extension NSManagedObject {

    @objc
    public static func singleObject(predicate: NSPredicate, inManagedObjectContext context: NSManagedObjectContext, includeSubentities: Bool) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        do {
            let result = try context.fetch(request)
            return result.last as? NSManagedObject
        } catch {
            return nil
        }
    }
}

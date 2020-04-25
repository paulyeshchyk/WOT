//
//  NSManagedObjectContext+AllObjects.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    @objc
    func deleteAllObjects() throws {
        if let entitesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName {
            for (_, entityDescription) in entitesByName {
                try deleteAllObjectsForEntity(entity: entityDescription)
            }
        }
    }

    func deleteAllObjectsForEntity(entity: NSEntityDescription) throws {
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

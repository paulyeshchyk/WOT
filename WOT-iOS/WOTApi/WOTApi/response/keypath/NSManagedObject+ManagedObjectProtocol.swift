//
//  NSManagedObject+ManagedObjectProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

extension NSManagedObject: ManagedObjectProtocol {
    public var entityName: String {
        return entity.name ?? "<unknown>"
    }

    public var managedObjectID: AnyObject {
        return objectID
    }

    public var fetchStatus: FetchStatus {
        isInserted ? .inserted : .fetched
    }
}

//
//  NSManagedObject+ManagedObjectProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

extension NSManagedObject: ManagedObjectProtocol {
    public var entityName: String { return entity.name ?? "<unknown>" }
    public var managedPin: AnyObject { return objectID }
    public var fetchStatus: FetchStatus { isInserted ? .inserted : .fetched }
    public var context: ManagedObjectContextProtocol? { managedObjectContext }

    public func fetchResult(managedPin: AnyObject?, managedObjectContext: ManagedObjectContextProtocol, predicate: NSPredicate?, fetchStatus: FetchStatus) -> FetchResultProtocol {
        return FetchResult(managedPin: managedPin, managedObjectContext: managedObjectContext, predicate: predicate, fetchStatus: fetchStatus)
    }
}

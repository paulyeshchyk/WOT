//
//  NSManagedObject+ManagedObjectProtocol.swift
//  WOTApi
//
//  Created by Paul on 26.12.22.
//

import ContextSDK
import CoreData

// MARK: - NSManagedObject + ManagedObjectProtocol

extension NSManagedObject: ManagedObjectProtocol {
    public var entityName: String { return entity.name ?? "<unknown>" }
    public var managedPin: ManagedPinProtocol { return ManagedPin(modelClass: type(of: self), managedObjectID: objectID) }
    public var fetchStatus: FetchStatus { isInserted ? .inserted : .fetched }
    public var context: ManagedObjectContextProtocol? { managedObjectContext }
}

// MARK: - ManagedPin

private class ManagedPin: ManagedPinProtocol {
    var modelClass: PrimaryKeypathProtocol.Type
    var managedObjectID: AnyObject
    init(modelClass: PrimaryKeypathProtocol.Type, managedObjectID: AnyObject) {
        self.modelClass = modelClass
        self.managedObjectID = managedObjectID
    }

}

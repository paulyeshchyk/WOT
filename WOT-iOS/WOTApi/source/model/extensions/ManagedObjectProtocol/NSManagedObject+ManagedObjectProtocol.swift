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
    //
    public var entityName: String { return entity.name ?? "<unknown>" }
    public var fetchStatus: FetchStatus {
        isInserted ?
            .inserted :
            .fetched
    }

    public var context: ManagedObjectContextProtocol? { managedObjectContext }
    public func managedRef() throws -> ManagedRefProtocol {
        return try ManagedRef(modelClass: type(of: self), managedObjectID: objectID)
    }

    public subscript(_ kp: KeypathType) -> Any? {
        guard let keypath = kp as? String else {
            fatalError("invalid keypath: \(kp)")
        }
        return value(forKeyPath: keypath)
    }
}

// MARK: - ManagedRef

private class ManagedRef: ManagedRefProtocol, CustomStringConvertible {
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var description: String {
        return "[\(type(of: self))] modelClass: \(String(describing: modelClass))"
    }

    var modelClass: ModelClassType
    var managedObjectID: AnyObject

    init(modelClass: AnyClass, managedObjectID: AnyObject) throws {
        guard let modelClass = modelClass as? ModelClassType else {
            throw ManagedRefError.classIsNotConforming(modelClass)
        }

        self.modelClass = modelClass
        self.managedObjectID = managedObjectID
    }
}

// MARK: - ManagedRefError

private enum ManagedRefError: Error, CustomStringConvertible {
    case classIsNotConforming(AnyClass)

    var description: String {
        switch self {
        case .classIsNotConforming(let anyclass): return "Class: \(anyclass) is not conforming \(type(of: (PrimaryKeypathProtocol & FetchableProtocol).Type.self))"
        }
    }
}

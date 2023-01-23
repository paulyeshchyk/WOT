//
//  ManagedObjectProtocol.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - ManagedObjectProtocol

@objc
public protocol ManagedObjectProtocol: FetchResultContainerProtocol {
    var entityName: String { get }
    var fetchStatus: FetchStatus { get }
    var managedObjectID: AnyObject { get }
    var context: ManagedObjectContextProtocol? { get }
}

// MARK: - FetchStatus

@objc
public enum FetchStatus: Int {
    case none
    case fetched
    case inserted
    case updated
    case recovered
}

extension ManagedObjectProtocol {
    @available(*, deprecated)
    public func fetchResult(context: ManagedObjectContextProtocol, predicate: NSPredicate? = nil, fetchStatus: FetchStatus? = nil) -> FetchResultProtocol {
        return FetchResult(objectID: managedObjectID, managedObjectContext: context, predicate: predicate, fetchStatus: fetchStatus ?? self.fetchStatus)
    }
}

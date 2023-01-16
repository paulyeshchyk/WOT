//
//  ManagedObjectProtocol.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - ManagedObjectProtocol

@objc
public protocol ManagedObjectProtocol {
    var entityName: String { get }
    var fetchStatus: FetchStatus { get }
    var managedRef: ManagedRefProtocol { get }
    var context: ManagedObjectContextProtocol? { get }
    subscript(_: KeypathType) -> Any? { get }
}

public typealias ManagedAndDecodableObjectType = (DecodableProtocol & ManagedObjectProtocol)

// MARK: - ManagedRefProtocol

@objc
public protocol ManagedRefProtocol {
    var modelClass: PrimaryKeypathProtocol.Type { get }
    var managedObjectID: AnyObject { get }
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
    //
    public func fetchResult(context: ManagedObjectContextProtocol, predicate: NSPredicate? = nil, fetchStatus: FetchStatus? = nil) -> FetchResultProtocol {
        return FetchResult(managedRef: managedRef, managedObjectContext: context, predicate: predicate, fetchStatus: fetchStatus ?? self.fetchStatus)
    }
}

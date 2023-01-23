//
//  FetchResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

@objc
public enum FetchStatus: Int {
    case none
    case fetched
    case inserted
    case updated
    case recovered
}

@objc
public protocol FetchResultProtocol: AnyObject {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    var objectContext: ManagedObjectContextProtocol? { get set }
    func makeDublicate() -> FetchResultProtocol
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext context: ManagedObjectContextProtocol?) -> ManagedObjectProtocol?
}

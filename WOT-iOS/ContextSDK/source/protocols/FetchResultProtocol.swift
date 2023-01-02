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
public protocol FetchResultProtocol: AnyObject, ManagedObjectContextContainerProtocol {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    func makeDublicate(inContext: ManagedObjectContextProtocol) -> FetchResultProtocol
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext context: ManagedObjectContextProtocol?) -> ManagedObjectProtocol?
}

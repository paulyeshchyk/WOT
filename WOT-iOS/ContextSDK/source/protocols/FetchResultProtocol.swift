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
public protocol FetchResultProtocol: ManagedObjectContextContainerProtocol {
    var fetchStatus: FetchStatus { get }
    var predicate: NSPredicate? { get set }
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext: ManagedObjectContextProtocol?) -> ManagedObjectProtocol?

    @available(*, deprecated, message: "make sure you need that")
    func makeDublicate(inContext: ManagedObjectContextProtocol) -> FetchResultProtocol
}

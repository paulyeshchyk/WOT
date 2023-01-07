//
//  FetchResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

// MARK: - FetchResultProtocol

@objc
public protocol FetchResultProtocol: ManagedObjectContextContainerProtocol {
    var fetchStatus: FetchStatus { get }
    var predicate: NSPredicate? { get set }
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext: ManagedObjectContextProtocol?) -> ManagedObjectProtocol?

    @available(*, deprecated, message: "make sure you need that")
    func makeDublicate(inContext: ManagedObjectContextProtocol) -> FetchResultProtocol
}

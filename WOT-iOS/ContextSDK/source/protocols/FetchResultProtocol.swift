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
    func makeDublicate(managedObjectContext: ManagedObjectContextProtocol) -> FetchResultProtocol
}
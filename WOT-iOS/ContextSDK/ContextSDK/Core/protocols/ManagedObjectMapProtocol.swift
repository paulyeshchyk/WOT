//
//  ManagedObjectMapProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

@objc
public protocol ManagedObjectMapProtocol: ContextPredicateContainerProtocol, ManagedObjectContextContainerProtocol {}

@objc
public protocol JSONManagedObjectMapProtocol: ManagedObjectMapProtocol {
    var mappingData: Any? { get }
}

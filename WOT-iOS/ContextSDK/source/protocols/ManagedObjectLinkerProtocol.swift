//
//  ManagedObjectLinkerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias ManagedObjectLinkerContext = DataStoreContainerProtocol
public typealias ManagedObjectLinkerCompletion = (FetchResultProtocol, Error?) -> Void

// MARK: - ManagedObjectLinkerProtocol

@objc
public protocol ManagedObjectLinkerProtocol: MD5Protocol {
    func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext?, completion: @escaping ManagedObjectLinkerCompletion)
}

// MARK: - ManagedObjectLinkerSocketProtocol

public protocol ManagedObjectLinkerSocketProtocol {
    var identifier: Any? { get }
    var keypath: KeypathType? { get }
}

// MARK: - ManagedObjectLinkerPinProtocol

public protocol ManagedObjectLinkerPinProtocol {
    var modelClass: PrimaryKeypathProtocol.Type { get }
    var identifier: JSONValueType? { get }
    var contextPredicate: ContextPredicateProtocol? { get }
}

//
//  ManagedObjectLinkerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias ManagedObjectLinkerCompletion = (FetchResultProtocol, Error?) -> Void

// MARK: - ManagedObjectLinkerProtocol

@objc
public protocol ManagedObjectLinkerProtocol: MD5Protocol {
    typealias Context = DataStoreContainerProtocol
    func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerProtocol.Context?, completion: @escaping ManagedObjectLinkerCompletion)
}

// MARK: - JointSocketProtocol

public protocol JointSocketProtocol {
    var identifier: Any? { get }
    var keypath: KeypathType? { get }
}

// MARK: - JointPinProtocol

public protocol JointPinProtocol {
    var modelClass: PrimaryKeypathProtocol.Type { get }
    var identifier: JSONValueType? { get }
    var contextPredicate: ContextPredicateProtocol? { get }
}

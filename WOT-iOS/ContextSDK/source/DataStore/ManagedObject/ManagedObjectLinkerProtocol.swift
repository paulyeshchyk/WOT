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

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol

    var socket: JointSocketProtocol? { get set }
    var fetchResult: FetchResultProtocol? { get set }
    var completion: ManagedObjectLinkerCompletion? { get set }

    init(appContext: Context)
    func run() throws
}

// MARK: - JointSocketProtocol

@objc
public protocol JointSocketProtocol {
    var identifier: Any? { get }
    var keypath: KeypathType? { get }
    var managedRef: ManagedRefProtocol { get }
}

// MARK: - JointPinProtocol

public protocol JointPinProtocol {

    var modelClass: ModelClassType { get }
    var identifier: JSONValueType? { get }
    var contextPredicate: ContextPredicateProtocol? { get }
}

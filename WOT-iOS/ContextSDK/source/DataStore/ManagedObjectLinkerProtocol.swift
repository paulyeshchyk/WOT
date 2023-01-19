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

    var socket: JointSocketProtocol? { get set }
    func process(fetchResult: FetchResultProtocol, appContext: Context?, completion: @escaping ManagedObjectLinkerCompletion) throws
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
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var modelClass: ModelClassType { get }
    var identifier: JSONValueType? { get }
    var contextPredicate: ContextPredicateProtocol? { get }
}

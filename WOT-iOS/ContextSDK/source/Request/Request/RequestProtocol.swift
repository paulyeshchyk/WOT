//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias RequestIdType = NSInteger

// MARK: - RequestProtocol

@objc
public protocol RequestProtocol: StartableProtocol, MD5Protocol {

    typealias Context = LogInspectorContainerProtocol
        & HostConfigurationContainerProtocol

    var availableInGroups: [RequestIdType] { get }
    var listeners: [RequestListenerProtocol] { get }
    var contextPredicate: ContextPredicateProtocol? { get }
    var arguments: RequestArgumentsProtocol? { get set }
    var decodingDepthLevel: DecodingDepthLevel? { get set }
    var responseConfiguration: ResponseConfigurationProtocol? { get set }

    // MARK: to be moved out from protocol

    var httpQueryItemName: String? { get }
    func httpAPIQueryPrefix() -> String?

    init(appContext: Context)

    func addGroup(_ group: RequestIdType)
    func addListener(_ listener: RequestListenerProtocol)
    func removeGroup(_ group: RequestIdType)
    func removeListener(_ listener: RequestListenerProtocol)
}

// MARK: - RequestListenerContainerProtocol

@objc
public protocol RequestListenerContainerProtocol {
    var requestListener: RequestListenerProtocol? { get set }
}

// MARK: - RequestListenerProtocol

@objc
public protocol RequestListenerProtocol: MD5Protocol {
    func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    func request(_ request: RequestProtocol, canceledWith error: Error?)
    func request(_ request: RequestProtocol, startedWith urlRequest: URLRequest)
}

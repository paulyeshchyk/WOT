//
//  RequestManagerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol RequestManagerContainerProtocol {
    @objc var requestManager: RequestManagerProtocol? { get set }
}

@objc
public protocol WOTRequestCoordinatorBridgeProtocol {
    func createRequest(forRequestId requestId: WOTRequestIdType) throws -> RequestProtocol
}

@objc
public protocol RequestManagerProtocol: WOTRequestCoordinatorBridgeProtocol {
    func addListener(_ listener: RequestManagerListenerProtocol?, forRequest: RequestProtocol)
    func removeListener(_ listener: RequestManagerListenerProtocol)
    func startRequest(_ request: RequestProtocol, withArguments arguments: RequestArgumentsProtocol, forGroupId: WOTRequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol) throws
    func startRequest(by requestId: WOTRequestIdType, paradigm: MappingParadigmProtocol) throws
    func cancelRequests(groupId: WOTRequestIdType, with error: Error?)
    func createRequest(forRequestId: WOTRequestIdType) throws -> RequestProtocol
    func requestIds(forRequest request: RequestProtocol) -> [WOTRequestIdType]
    func fetchRemote(paradigm: MappingParadigmProtocol)
}

//
//  WOTRequestManagerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestCoordinatorBridgeProtocol {
    func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol
}

@objc
public protocol WOTRequestManagerProtocol: WOTRequestCoordinatorBridgeProtocol {
    func addListener(_ listener: WOTRequestManagerListenerProtocol?, forRequest: WOTRequestProtocol)
    func removeListener(_ listener: WOTRequestManagerListenerProtocol)
    func startRequest(_ request: WOTRequestProtocol, withArguments arguments: WOTRequestArgumentsProtocol, forGroupId: WOTRequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol) throws
    func startRequest(by requestId: WOTRequestIdType, paradigm: RequestParadigmProtocol) throws
    func cancelRequests(groupId: WOTRequestIdType, with error: Error?)
    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]
    func fetchRemote(paradigm: RequestParadigmProtocol)
}

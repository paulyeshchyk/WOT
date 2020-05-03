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
    var appManager: WOTAppManagerProtocol? { get set }

    var coordinator: WOTRequestCoordinatorProtocol { get }

    var hostConfiguration: WOTHostConfigurationProtocol { get set }

    func addListener(_ listener: WOTRequestManagerListenerProtocol?, forRequest: WOTRequestProtocol)

    func removeListener(_ listener: WOTRequestManagerListenerProtocol)

    func startRequest(_ request: WOTRequestProtocol, withArguments arguments: WOTRequestArgumentsProtocol, forGroupId: WOTRequestIdType, instanceHelper: JSONAdapterInstanceHelper?) throws

    func startRequest(by requestId: WOTRequestIdType, withPredicate: WOTPredicate, instanceHelper: JSONAdapterInstanceHelper?) throws

    func cancelRequests(groupId: WOTRequestIdType, with error: Error?)
}

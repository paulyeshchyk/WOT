//
//  WOTRequestCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestCoordinatorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]
}

@objc
public protocol WOTRequestRegistratorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]
    func unregisterDataAdapter(for requestId: WOTRequestIdType)
    func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol) throws -> JSONAdapterProtocol
    func dataAdapterClass(for requestId: WOTRequestIdType) -> JSONAdapterProtocol.Type?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type)
    func requestClass(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type?
    func modelClass(forRequest: WOTRequestProtocol) -> PrimaryKeypathProtocol.Type?
    func modelClass(forRequestIdType: WOTRequestIdType) -> PrimaryKeypathProtocol.Type?
}

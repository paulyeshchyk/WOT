//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol RequestRegistratorContainerProtocol {
    var requestRegistrator: RequestRegistratorProtocol? { get set }
}

@objc
public protocol RequestRegistratorProtocol {

    func requestIds(forClass: AnyClass) -> [RequestIdType]
    func requestIds(forRequest request: RequestProtocol) throws -> [RequestIdType]
    func unregisterDataAdapter(for requestId: RequestIdType)
    func requestClass(for requestId: RequestIdType) -> ModelServiceProtocol.Type?
    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol
    func modelClass(forRequest: RequestProtocol) -> PrimaryKeypathProtocol.Type?
    func modelClass(forRequestIdType: RequestIdType) throws -> PrimaryKeypathProtocol.Type
    func dataAdapterClass(for requestId: RequestIdType) -> ResponseAdapterProtocol.Type?
    func register(dataAdapterClass: ResponseAdapterProtocol.Type, modelClass requestClass: ModelServiceProtocol.Type)
}

//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol RequestRegistratorContainerProtocol {
    @objc var requestRegistrator: RequestRegistratorProtocol? { get set }
}

@objc
public protocol RequestRegistratorProtocol {

    func requestIds(forClass: AnyClass) -> [RequestIdType]
    func unregisterDataAdapter(for requestId: RequestIdType)
    func dataAdapterClass(for requestId: RequestIdType) -> JSONAdapterProtocol.Type?
    func requestId(_ requiestId: RequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type)
    func requestClass(for requestId: RequestIdType) -> WOTModelServiceProtocol.Type?
    func modelClass(forRequest: RequestProtocol) -> PrimaryKeypathProtocol.Type?
    func modelClass(forRequestIdType: RequestIdType) -> PrimaryKeypathProtocol.Type?
}

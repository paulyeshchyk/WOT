//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol WOTRequestRegistratorProtocol {

    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]
    func unregisterDataAdapter(for requestId: WOTRequestIdType)
    func dataAdapterClass(for requestId: WOTRequestIdType) -> JSONAdapterProtocol.Type?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type)
    func requestClass(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type?
    func modelClass(forRequest: RequestProtocol) -> PrimaryKeypathProtocol.Type?
    func modelClass(forRequestIdType: WOTRequestIdType) -> PrimaryKeypathProtocol.Type?
}

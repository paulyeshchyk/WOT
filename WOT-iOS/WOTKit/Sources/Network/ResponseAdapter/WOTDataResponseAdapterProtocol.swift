//
//  WOTDataResponseAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestIdType = String

@objc
public protocol WOTDataResponseAdapterProtocol: NSObjectProtocol {
    init(appManager: WOTAppManagerProtocol?, clazz: PrimaryKeypathProtocol.Type)
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, linker: JSONAdapterLinkerProtocol?, onRequestComplete: @escaping OnRequestComplete ) -> JSONAdapterProtocol
}

public protocol WOTRequestBindingProtocol {
    func unregisterDataAdapter(for requestId: WOTRequestIdType)
    func dataAdapterClass(for requestId: WOTRequestIdType) -> JSONAdapterProtocol.Type?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type)
    func request(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type?
}

//
//  WOTResponseAdapterCreatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol WOTResponseAdapterCreatorProtocol {
    func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) throws -> JSONAdapterProtocol
    func responseAdapterInstances(byRequestIdTypes: [WOTRequestIdType], request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) -> [DataAdapterProtocol]
}

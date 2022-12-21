//
//  WOTResponseAdapterCreatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol ResponseAdapterCreatorContainerProtocol {
    var responseAdapterCreator: ResponseAdapterCreatorProtocol? { get set }
}

@objc
public protocol ResponseAdapterCreatorProtocol {
    func responseAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) throws -> JSONAdapterProtocol
    func responseAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) -> [DataAdapterProtocol]
}

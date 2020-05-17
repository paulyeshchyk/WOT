//
//  WOTResponseAdapterCreatorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTResponseAdapterCreatorProtocol {
    func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) throws -> JSONAdapterProtocol
    func responseAdapterInstances(byRequestIdTypes: [WOTRequestIdType], request: WOTRequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) -> [DataAdapterProtocol]
}

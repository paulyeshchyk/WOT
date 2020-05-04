//
//  WOTRequestCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestCoordinatorProtocol: LogInspectorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]?
    func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]?
    func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol) throws -> JSONAdapterProtocol
}

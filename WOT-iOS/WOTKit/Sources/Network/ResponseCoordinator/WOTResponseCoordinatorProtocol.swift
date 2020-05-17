//
//  WOTResponseCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTResponseCoordinatorProtocol: LogInspectorProtocol {
    init(requestCoordinator: WOTRequestCoordinatorProtocol, logInspector: LogInspectorProtocol, requestRegistrator: WOTRequestRegistratorProtocol)
    func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol, onRequestComplete: @escaping OnRequestComplete) throws
}

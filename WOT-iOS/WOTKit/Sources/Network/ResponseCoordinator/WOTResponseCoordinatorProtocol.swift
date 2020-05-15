//
//  WOTResponseCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTResponseCoordinatorHolderProtocol {
    var responseCoordinator: WOTResponseCoordinatorProtocol { get }
}

@objc
public protocol WOTResponseCoordinatorProtocol: LogInspectorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }

    init(requestCoordinator: WOTRequestCoordinatorProtocol)
    func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol, onRequestComplete: @escaping OnRequestComplete) throws
}

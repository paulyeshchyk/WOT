//
//  WOTResponseCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTResponseCoordinatorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }

    init(requestCoordinator: WOTRequestCoordinatorProtocol)
    func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, instanceHelper: JSONAdapterInstanceHelper?, onComplete: @escaping OnRequestComplete) throws
}

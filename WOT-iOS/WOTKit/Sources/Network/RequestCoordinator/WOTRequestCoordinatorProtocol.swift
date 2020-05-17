//
//  WOTRequestCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestCoordinatorProtocol {

    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]
}

//
//  WOTResponseCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol WOTResponseParserProtocol {
    func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, adapters: [DataAdapterProtocol], onParseComplete: @escaping OnParseComplete) throws
}

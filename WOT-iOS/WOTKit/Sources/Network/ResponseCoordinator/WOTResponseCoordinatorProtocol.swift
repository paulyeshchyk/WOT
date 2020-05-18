//
//  WOTResponseCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTResponseParserProtocol {
    func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, adapters: [DataAdapterProtocol], onParseComplete: @escaping OnParseComplete) throws
}

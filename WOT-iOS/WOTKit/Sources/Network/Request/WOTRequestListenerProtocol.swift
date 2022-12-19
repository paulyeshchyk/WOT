//
//  WOTRequestManagerListenerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol WOTRequestManagerListenerProtocol {
    var uuidHash: Int { get }

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: RequestProtocol)
}

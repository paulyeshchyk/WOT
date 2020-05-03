//
//  WOTRequestManagerListenerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol WOTRequestManagerListenerProtocol {
    var uuidHash: Int { get }

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: WOTRequestProtocol, completionResultType: WOTRequestManagerCompletionResultType, error: Error?)

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: WOTRequestProtocol)
}

@objc
public protocol WOTRequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: WOTRequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: WOTRequestProtocol, startedWith hostConfiguration: WOTHostConfigurationProtocol, args: WOTRequestArgumentsProtocol)
}

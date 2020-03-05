//
//  WebRequestListenerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation


@objc
public protocol WebRequestListenerProtocol {
    
    @objc
    var hash: Int { get }
    
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol { get set }
    
    @objc
    func requestHasFinishedLoadData(_ request: Any, error: Error?)

    @objc
    func requestHasCanceled(_ request: Any)

    @objc
    func requestHasStarted(_ request: Any)

    @objc
    func removeRequest(_ request: Any)
}

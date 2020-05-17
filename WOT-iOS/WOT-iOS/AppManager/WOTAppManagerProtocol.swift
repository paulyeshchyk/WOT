//
//  WOTAppManagerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTAppManagerProtocol {
    @objc var hostConfiguration: WOTHostConfigurationProtocol? { get set }
    @objc var responseParser: WOTResponseParserProtocol? { get set }
    @objc var requestManager: WOTRequestManagerProtocol? { get set }
    @objc var requestListener: WOTRequestListenerProtocol? { get set }
    @objc var sessionManager: WOTWebSessionManagerProtocol? { get set }
    @objc var logInspector: LogInspectorProtocol? { get set }
    @objc var coreDataStore: WOTCoredataStoreProtocol? { get set }
    @objc var requestRegistrator: WOTRequestRegistratorProtocol? { get set }
}

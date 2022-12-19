//
//  WOTAppManagerProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol WOTAppManagerProtocol {
    @objc var hostConfiguration: HostConfigurationProtocol? { get set }
    @objc var responseParser: WOTResponseParserProtocol? { get set }
    @objc var requestManager: WOTRequestManagerProtocol? { get set }
    @objc var requestListener: RequestListenerProtocol? { get set }
    @objc var sessionManager: WOTWebSessionManagerProtocol? { get set }
    @objc var logInspector: LogInspectorProtocol? { get set }
    @objc var coreDataStore: DataStoreProtocol? { get set }
    @objc var requestRegistrator: WOTRequestRegistratorProtocol? { get set }
}

//
//  WOTPivotAppManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class WOTPivotAppManager: NSObject, WOTAppManagerProtocol {
    public var hostConfiguration: HostConfigurationProtocol?
    public var responseParser: WOTResponseParserProtocol?
    public var requestManager: WOTRequestManagerProtocol?
    public var requestListener: RequestListenerProtocol?
    public var sessionManager: WOTWebSessionManagerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: DataStoreProtocol?
    public var requestRegistrator: WOTRequestRegistratorProtocol?
}

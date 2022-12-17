//
//  WOTPivotAppManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTPivotAppManager: NSObject, WOTAppManagerProtocol {
    public var hostConfiguration: WOTHostConfigurationProtocol?
    public var responseParser: WOTResponseParserProtocol?
    public var requestManager: WOTRequestManagerProtocol?
    public var requestListener: WOTRequestListenerProtocol?
    public var sessionManager: WOTWebSessionManagerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: WOTCoredataStoreProtocol?
    public var requestRegistrator: WOTRequestRegistratorProtocol?
}

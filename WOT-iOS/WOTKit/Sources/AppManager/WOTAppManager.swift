//
//  WOTPivotAppManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTPivotAppManager: NSObject, WOTAppManagerProtocol {
    //
    deinit {
        sessionManager?.appManager = nil
    }

    public var hostConfiguration: WOTHostConfigurationProtocol?

    public var responseCoordinator: WOTResponseCoordinatorProtocol?

    public var requestCoordinator: WOTRequestCoordinatorProtocol?

    public var requestManager: WOTRequestManagerProtocol?

    public var mappingCoordinator: WOTMappingCoordinatorProtocol?

    public var requestListener: WOTRequestListenerProtocol?

    public var sessionManager: WOTWebSessionManagerProtocol? {
        didSet {
            sessionManager?.appManager = self
        }
    }

    public var logInspector: LogInspectorProtocol?

    public var coreDataStore: WOTCoredataStoreProtocol?
}

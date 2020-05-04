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
        responseCoordinator?.appManager = nil
        requestCoordinator?.appManager = nil
        requestManager?.appManager = nil
        mappingCoordinator?.appManager = nil
        sessionManager?.appManager = nil
    }

    public var hostConfiguration: WOTHostConfigurationProtocol?

    public var responseCoordinator: WOTResponseCoordinatorProtocol? {
        didSet {
            responseCoordinator?.appManager = self
        }
    }

    public var requestCoordinator: WOTRequestCoordinatorProtocol? {
        didSet {
            requestCoordinator?.appManager = self
        }
    }

    public var requestManager: WOTRequestManagerProtocol? {
        didSet {
            requestManager?.appManager = self
        }
    }

    public var mappingCoordinator: WOTMappingCoordinatorProtocol? {
        didSet {
            mappingCoordinator?.appManager = self
        }
    }

    public var requestListener: WOTRequestListenerProtocol?

    public var sessionManager: WOTWebSessionManagerProtocol? {
        didSet {
            sessionManager?.appManager = self
        }
    }

    public var logInspector: LogInspectorProtocol?

    public var coreDataStore: WOTCoredataStoreProtocol? {
        didSet {
            coreDataStore?.appManager = self
        }
    }
}

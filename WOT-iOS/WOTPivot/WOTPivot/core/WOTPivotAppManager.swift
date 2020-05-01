//
//  WOTPivotAppManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTAppManagerProtocol {
    @objc var hostConfiguration: WOTHostConfigurationProtocol? { get set }
    @objc var requestCoordinator: WOTRequestCoordinatorProtocol? { get set }
    @objc var requestManager: WOTRequestManagerProtocol? { get set }
    @objc var requestListener: WOTRequestListenerProtocol? { get set }
    @objc var sessionManager: WOTWebSessionManagerProtocol? { get set }
    @objc var logInspector: LogInspectorProtocol? { get set }
    @objc var coreDataProvider: WOTCoredataProviderProtocol? { get set }
    @objc var persistentStore: WOTPersistentStoreProtocol? { get set }
    @objc var responseCoordinator: WOTResponseCoordinatorProtocol? { get set }
}

@objc
public class WOTPivotAppManager: NSObject, WOTAppManagerProtocol {
    //

    deinit {
        responseCoordinator?.appManager = nil
        requestCoordinator?.appManager = nil
        requestManager?.appManager = nil
        persistentStore?.appManager = nil
        sessionManager?.appManager = nil
    }

    @objc public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc public var responseCoordinator: WOTResponseCoordinatorProtocol? {
        didSet {
            responseCoordinator?.appManager = self
        }
    }

    @objc public var requestCoordinator: WOTRequestCoordinatorProtocol? {
        didSet {
            requestCoordinator?.appManager = self
        }
    }

    @objc public var requestManager: WOTRequestManagerProtocol? {
        didSet {
            requestManager?.appManager = self
        }
    }

    @objc public var persistentStore: WOTPersistentStoreProtocol? {
        didSet {
            persistentStore?.appManager = self
        }
    }

    @objc public var requestListener: WOTRequestListenerProtocol?

    @objc public var sessionManager: WOTWebSessionManagerProtocol? {
        didSet {
            sessionManager?.appManager = self
        }
    }

    @objc public var logInspector: LogInspectorProtocol?

    @objc public var coreDataProvider: WOTCoredataProviderProtocol? {
        didSet {
            coreDataProvider?.appManager = self
        }
    }
}

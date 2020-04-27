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
    @objc var shared: WOTAppManagerProtocol { get }
    @objc var persistentStore: WOTPersistentStoreProtocol? { get set }
}

@objc
public class WOTPivotAppManager: NSObject, WOTAppManagerProtocol {
    @objc public static let sharedInstance = WOTPivotAppManager()
    @objc public var shared: WOTAppManagerProtocol { return WOTPivotAppManager.sharedInstance }
    @objc public var hostConfiguration: WOTHostConfigurationProtocol?
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

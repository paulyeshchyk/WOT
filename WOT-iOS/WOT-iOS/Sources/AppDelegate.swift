//
//  AppDelegate.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - AppDelegate

@objc
public class AppDelegate: UIResponder, UIApplicationDelegate, ContextProtocol {
    public var window: UIWindow?

    public var hostConfiguration: HostConfigurationProtocol?
    public var requestManager: RequestManagerProtocol?
    public var requestListener: RequestListenerProtocol?
    public var sessionManager: SessionManagerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var dataStore: DataStoreProtocol?
    public var mappingCoordinator: MappingCoordinatorProtocol?
    public var responseDataAdapterCreator: ResponseDataAdapterCreatorProtocol?

    public func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let logPriorities: [LogEventType]? = [.error, .warning, .flow, .longTermOperation, .pivot, .custom, .lifeCycle]
        logInspector = LogInspector(priorities: logPriorities, output: [OSLogWrapper(consoleLevel: .verbose, bundle: Bundle.main)])

        hostConfiguration = WOTHostConfiguration()
        sessionManager = SessionManager()
        dataStore = WOTDataStore(appContext: self)
        mappingCoordinator = MappingCoordinator(appContext: self)
        responseDataAdapterCreator = ResponseDataAdapterCreator(appContext: self)
        requestManager = WOTRequestManager(appContext: self)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WOTDrawerViewController.newDrawer()
        window?.makeKeyAndVisible()

        return true
    }
}

// MARK: - AppDelegate + ResponseDataAdapterCreatorContainerProtocol

extension AppDelegate: ResponseDataAdapterCreatorContainerProtocol {}

//
//  AppDelegate.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

@objc
public class AppDelegate: UIResponder, UIApplicationDelegate, ContextProtocol {
    public var window: UIWindow?

    public var hostConfiguration: HostConfigurationProtocol?
    public var requestManager: RequestManagerProtocol?
    public var requestListener: RequestListenerProtocol?
    public var sessionManager: SessionManagerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var dataStore: DataStoreProtocol?
    public var requestRegistrator: RequestRegistratorProtocol?
    public var mappingCoordinator: MappingCoordinatorProtocol?
    public var responseDataAdapterCreator: ResponseDataAdapterCreatorProtocol?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let logPriorities: [LogEventType]? = [.error, .web, .warning]
        logInspector = LogInspector(priorities: logPriorities, output: [OSLogWrapper(consoleLevel: .verbose, bundle: Bundle.main)])

        hostConfiguration = WOTHostConfiguration()
        sessionManager = SessionManager()
        dataStore = WOTDataStore(context: self)
        requestRegistrator = WOTRequestRegistrator(context: self)
        mappingCoordinator = MappingCoordinator(context: self)
        responseDataAdapterCreator = ResponseDataAdapterCreator(context: self)
        requestManager = RequestManager(context: self)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WOTDrawerViewController.newDrawer()
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate: RequestRegistratorContainerProtocol, ResponseDataAdapterCreatorContainerProtocol {
    
}

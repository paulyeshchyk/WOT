//
//  AppDelegate.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class AppDelegate: UIResponder, UIApplicationDelegate, WOTAppDelegateProtocol {
    public var window: UIWindow?

    public var hostConfiguration: HostConfigurationProtocol?
    public var responseParser: WOTResponseParserProtocol?
    public var requestManager: RequestManagerProtocol?
    public var requestListener: RequestListenerProtocol?
    public var sessionManager: SessionManagerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var dataStore: DataStoreProtocol?
    public var requestRegistrator: RequestRegistratorProtocol?
    public var mappingCoordinator: MappingCoordinatorProtocol?
    public var responseAdapterCreator: ResponseAdapterCreatorProtocol?

    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //

        let logPriorities: [LogEventType]? = [.error, .web, .warning, .lifeCycle]
        logInspector = LogInspector(priorities: logPriorities, output: [OSLogWrapper(consoleLevel: .verbose, bundle: Bundle.main)])

        hostConfiguration = HostConfiguration()
        sessionManager = SessionManager()
        dataStore = WOTDataStore(context: self)
        requestRegistrator = WOTRequestRegistrator(context: self)
        mappingCoordinator = MappingCoordinator(context: self)
        responseAdapterCreator = ResponseAdapterCreator(context: self)

        responseParser = RESTResponseParser(context: self)
        requestManager = RequestManager(context: self)

        let drawerViewController: WOTDrawerViewController = WOTDrawerViewController.newDrawer()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = drawerViewController
        window?.makeKeyAndVisible()

        return true
    }
}

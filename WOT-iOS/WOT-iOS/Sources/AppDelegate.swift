//
//  AppDelegate.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - AppDelegate

@objc
public class AppDelegate: UIResponder, UIApplicationDelegate, ContextProtocol {
    public var window: UIWindow?

    public var hostConfiguration: HostConfigurationProtocol?
    public var requestManager: RequestManagerProtocol?
    public var requestListener: RequestListenerProtocol?
    public var logInspector: LogInspectorProtocol?
    public var dataStore: DataStoreProtocol?
    public var decoderManager: DecoderManagerProtocol?
    public var responseManager: ResponseManagerProtocol?

    // MARK: Public

    public func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let logPriorities: [LogEventType]? = [.error, .warning, .flow, .custom, .remoteFetch, .sqlite]
        logInspector = LogInspector(priorities: logPriorities, output: [OSLogWrapper(consoleLevel: .verbose, bundle: Bundle.main)])

        hostConfiguration = WOTHostConfiguration()
        dataStore = WOTDataStore(appContext: self)
        requestManager = WOTRequestManager(appContext: self)
        decoderManager = WOTDecoderManager()
        responseManager = WOTResponseManager(appContext: self)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WOTDrawerViewController.newDrawer()
        window?.makeKeyAndVisible()

        return true
    }
}

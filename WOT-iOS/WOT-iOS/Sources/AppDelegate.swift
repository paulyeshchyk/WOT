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

    private let logPriorities: [LogEventType]? = [.error, .warning, .flow, .custom, .remoteFetch, .uow, .sqlite]
    private let logOutput = OSLogWrapper(consoleLevel: .verbose, bundle: Bundle.main)

    public lazy var uowManager: UOWManagerProtocol = UOWManager(appContext: self)
    public lazy var logInspector: LogInspectorProtocol? = LogInspector(priorities: logPriorities, output: [logOutput])
    public lazy var hostConfiguration: HostConfigurationProtocol? = WOTHostConfiguration()
    public lazy var requestRegistrator: RequestRegistratorProtocol? = WOTRequestRegistrator(appContext: self)
    public lazy var requestManager: RequestManagerProtocol? = RequestManager(appContext: self)
    public lazy var responseManager: ResponseManagerProtocol? = WOTResponseManager(appContext: self)
    public lazy var dataStore: DataStoreProtocol? = WOTDataStore(appContext: self)
    public lazy var decoderManager: DecoderManagerProtocol? = WOTDecoderManager()
    public var requestListener: RequestListenerProtocol?

    // MARK: Public

    public func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WOTDrawerViewController.newDrawer()
        window?.makeKeyAndVisible()

        return true
    }
}

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
    public let appManager: WOTAppManagerProtocol = WOTPivotAppManager()

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //
        let hostConfiguration = WOTWebHostConfiguration()
        let requestCoordinator = WOTRequestCoordinator()
        let requestManager = WOTRequestManager(requestCoordinator: requestCoordinator, hostConfiguration: hostConfiguration)
        let sessionManager = WOTWebSessionManager()
        let logInspector = LogInspector(priorities: [.error, .lifeCycle, .json, .coredata])
        let coreDataProvider = WOTTankCoreDataProvider()
        let persistentStore = WOTPersistentStore()

        appManager.hostConfiguration = hostConfiguration
        appManager.requestCoordinator = requestCoordinator
        appManager.requestManager = requestManager
        appManager.requestListener = requestManager
        appManager.sessionManager = sessionManager
        appManager.logInspector = logInspector
        appManager.coreDataProvider = coreDataProvider
        appManager.persistentStore = persistentStore

        AppDefaults.registerRequests(for: requestCoordinator)

        let drawerViewController: WOTDrawerViewController = WOTDrawerViewController.newDrawer()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = drawerViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}

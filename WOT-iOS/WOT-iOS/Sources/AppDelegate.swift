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

//        let logPriorities = Set(LogEventType.allValues).subtracting([LogEventType.performance]).compactMap {$0}
        let logPriorities: [LogEventType] = [.localFetch, .remoteFetch, .error, .lifeCycle, .web, .json]
        let logInspector = LogInspector(priorities: logPriorities)

        let hostConfiguration = WOTWebHostConfiguration()
        let sessionManager = WOTWebSessionManager()
        let coreDataStore = WOTCustomCoreDataStore(logInspector: logInspector)

        let fetcherAndDecoder = WOTFetcherAndDecoder()

        let requestRegistrator = WOTRequestRegistrator()

        let responseParser = RESTResponseParser()
        let requestManager = WOTRequestManager(requestRegistrator: requestRegistrator, responseParser: responseParser, logInspector: logInspector, hostConfiguration: hostConfiguration)
        let fetcher = WOTFetcher()

        let linker = WOTLinker(logInspector: logInspector, fetcherAndDecoder: fetcherAndDecoder)
        let decoderAndMapper = WOTDecoderAndMapper(logInspector: logInspector, coreDataStore: coreDataStore, fetcher: fetcher, linker: linker, fetcherAndDecoder: fetcherAndDecoder)

        fetcher.coreDataStore = coreDataStore
        fetcher.logInspector = logInspector
        fetcher.requestManager = requestManager
        fetcher.requestRegistrator = requestRegistrator

        fetcherAndDecoder.coreDataStore = coreDataStore
        fetcherAndDecoder.decoderAndMapper = decoderAndMapper
        fetcherAndDecoder.fetcher = fetcher
        fetcherAndDecoder.logInspector = logInspector

        requestRegistrator.decoderAndMapper = decoderAndMapper
        requestRegistrator.logInspector = logInspector
        requestRegistrator.coreDataStore = coreDataStore

        appManager.hostConfiguration = hostConfiguration
        appManager.responseParser = responseParser
        appManager.requestManager = requestManager
        appManager.requestListener = requestManager
        appManager.sessionManager = sessionManager
        appManager.logInspector = logInspector
        appManager.coreDataStore = coreDataStore
        appManager.requestRegistrator = requestRegistrator

        requestRegistrator.registerDefaultRequests()

        let drawerViewController: WOTDrawerViewController = WOTDrawerViewController.newDrawer()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = drawerViewController
        window?.makeKeyAndVisible()

        return true
    }
}

extension WOTRequestRegistrator {
    public func registerDefaultRequests() {
        requestId(WebRequestType.guns.rawValue, registerRequestClass: WOTWEBRequestTankGuns.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.login.rawValue, registerRequestClass: WOTWEBRequestLogin.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.radios.rawValue, registerRequestClass: WOTWEBRequestTankRadios.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.logout.rawValue, registerRequestClass: WOTWEBRequestLogout.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.turrets.rawValue, registerRequestClass: WOTWEBRequestTankTurrets.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.modules.rawValue, registerRequestClass: WOTWEBRequestModules.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.engines.rawValue, registerRequestClass: WOTWEBRequestTankEngines.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.vehicles.rawValue, registerRequestClass: WOTWEBRequestTankVehicles.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.moduleTree.rawValue, registerRequestClass: WOTWEBRequestModulesTree.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.suspension.rawValue, registerRequestClass: WOTWEBRequestSuspension.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.sessionSave.rawValue, registerRequestClass: WOTSaveSessionRequest.self, registerDataAdapterClass: JSONAdapter.self)
        requestId(WebRequestType.sessionClear.rawValue, registerRequestClass: WOTClearSessionRequest.self, registerDataAdapterClass: JSONAdapter.self)
    }
}

public enum WebRequestType: String {
    case unknown
    case login
    case logout
    case sessionSave
    case sessionClear
    case suspension
    case turrets
    case guns
    case radios
    case engines
    case vehicles
    case modules
    case moduleTree
    case tankProfile
}

//
//  AppContext.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 5/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

typealias AppContextHolderProtocol = WOTHostConfigurationHolderProtocol
    & WOTRequestManagerHolderProtocol
    & WOTWebSessionManagerHolderProtocol
    & LogInspectorHolderProtocol
    & WOTCoreDataStoreHolderProtocol
    & WOTMappingCoordinatorHolderProtocol
    & WOTResponseCoordinatorHolderProtocol

public class AppContext: NSObject, AppContextHolderProtocol {
    public let responseCoordinator: WOTResponseCoordinatorProtocol
    public let mappingCoordinator: WOTMappingCoordinatorProtocol
    public let coreDataStore: WOTCoredataStoreProtocol
    public let logInspector: LogInspectorProtocol
    public let webSessionManager: WOTWebSessionManagerProtocol
    public let requestManager: WOTRequestManagerProtocol
    public let hostConfiguration: WOTHostConfigurationProtocol

    init(responseCoordinator: WOTResponseCoordinatorProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol, coreDataStore: WOTCoredataStoreProtocol, logInspector: LogInspectorProtocol, webSessionManager: WOTWebSessionManagerProtocol, requestManager: WOTRequestManagerProtocol, hostConfiguration: WOTHostConfigurationProtocol) {
        self.responseCoordinator = responseCoordinator
        self.mappingCoordinator = mappingCoordinator
        self.coreDataStore = coreDataStore
        self.logInspector = logInspector
        self.webSessionManager = webSessionManager
        self.requestManager = requestManager
        self.hostConfiguration = hostConfiguration
    }

    static func makeContext() -> AppContext {
        let logPriorities: [LogEventType] = [.localFetch, .remoteFetch, .error, .lifeCycle, .web, .json]
        let logInspector = LogInspector(priorities: logPriorities)

        let requestCoordinator = WOTRequestCoordinator(logInspector: logInspector)
        let responseCoordinator = RESTResponseCoordinator(requestCoordinator: requestCoordinator, logInspector: logInspector)

        let hostConfiguration = WOTWebHostConfiguration()
        let requestManager = WOTRequestManager(requestCoordinator: requestCoordinator, hostConfiguration: hostConfiguration, logInspector: logInspector, responseCoordinator: responseCoordinator)
        let sessionManager = WOTWebSessionManager()
        let coreDataProvider = WOTCustomCoreDataProvider(logInspector: logInspector)
        let mappingCoordinator = WOTMappingCoordinator(logInspector: logInspector, coreDataStore: coreDataProvider, requestManager: requestManager, requestCoordinator: requestCoordinator)

        return AppContext(responseCoordinator: responseCoordinator,
                          mappingCoordinator: mappingCoordinator,
                          coreDataStore: coreDataProvider,
                          logInspector: logInspector,
                          webSessionManager: sessionManager,
                          requestManager: requestManager,
                          hostConfiguration: hostConfiguration)
    }
}

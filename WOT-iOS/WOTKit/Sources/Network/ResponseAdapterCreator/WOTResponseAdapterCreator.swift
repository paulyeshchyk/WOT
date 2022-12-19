//
//  WOTResponseAdapterCreator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTResponseAdapterCreator: WOTResponseAdapterCreatorProtocol {
    private let logInspector: LogInspectorProtocol
    private let coreDataStore: WOTDataLocalStoreProtocol
    private let mappingCoordinator: WOTMappingCoordinatorProtocol
    private let requestRegistrator: WOTRequestRegistratorProtocol

    public init(logInspector: LogInspectorProtocol, coreDataStore: WOTDataLocalStoreProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol, requestRegistrator: WOTRequestRegistratorProtocol) {
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
        self.mappingCoordinator = mappingCoordinator
        self.requestRegistrator = requestRegistrator
    }

    public func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) throws -> JSONAdapterProtocol {
        guard let modelClass = requestRegistrator.modelClass(forRequestIdType: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType.description)
        }
        guard let dataAdapterClass = requestRegistrator.dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType.description)
        }

        return dataAdapterClass.init(Clazz: modelClass, request: request, logInspector: logInspector, coreDataStore: coreDataStore, jsonAdapterLinker: jsonAdapterLinker, mappingCoordinator: mappingCoordinator, requestManager: requestManager)
    }

    public func responseAdapterInstances(byRequestIdTypes: [WOTRequestIdType], request: WOTRequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: WOTRequestManagerProtocol) -> [DataAdapterProtocol] {
        var adapters: [DataAdapterProtocol] = .init()
        byRequestIdTypes.forEach { requestIdType in
            do {
                let adapter = try self.responseAdapterInstance(for: requestIdType, request: request, jsonAdapterLinker: jsonAdapterLinker, requestManager: requestManager)
                adapters.append(adapter)
            } catch {
                logInspector.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        return adapters
    }
}

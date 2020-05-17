//
//  WOTRequestCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {
    public var appManager: WOTAppManagerProtocol?
    private var requestRegistrator: WOTRequestRegistratorProtocol

    private var logInspector: LogInspectorProtocol? {
        return appManager?.logInspector
    }

    required public init(requestRegistrator: WOTRequestRegistratorProtocol) {
        self.requestRegistrator = requestRegistrator
        super.init()
    }

    // MARK: - WOTRequestCoordinatorProtocol

    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        guard
            let Clazz = requestRegistrator.requestClass(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self),
            let result = Clazz.init() as? WOTRequestProtocol else {
            throw RequestCoordinatorError.requestNotFound
        }
        return result
    }

    public func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType] {
        guard let modelClass = requestRegistrator.modelClass(forRequest: request) else {
            let eventError = EventError(message: "model class not found for request\(type(of: request))")
            logInspector?.logEvent(eventError, sender: self)
            return []
        }

        let result = requestRegistrator.requestIds(forClass: modelClass)
        guard result.count > 0 else {
            let eventError = EventError(message: "\(type(of: modelClass)) was not registered for request \(type(of: request))")
            logInspector?.logEvent(eventError, sender: self)
            return []
        }
        return result
    }
}

public class WOTRequestRegistrator: WOTRequestRegistratorProtocol {
    public var appManager: WOTAppManagerProtocol?

    private var registeredRequests: [WOTRequestIdType: WOTModelServiceProtocol.Type] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: JSONAdapterProtocol.Type] = .init()

    public init() {
        //
    }
    // MARK: - WOTRequestBindingProtocol
    
    public func requestIds(forClass: AnyClass) -> [WOTRequestIdType] {
        let result = registeredRequests.keys.filter {
            forClass == registeredRequests[$0]?.modelClass()
        }
        return result
    }


    public func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol) throws -> JSONAdapterProtocol {
        guard let modelClass = self.modelClass(forRequestIdType: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType.description)
        }
        guard let dataAdapterClass = self.dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType.description)
        }

        return dataAdapterClass.init(Clazz: modelClass, request: request, appManager: appManager, linker: linker)
    }

    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type) {
        registeredRequests[requiestId] = requestClass
        registeredDataAdapters[requiestId] = dataAdapterClass
    }

    public func unregisterDataAdapter(for requestId: WOTRequestIdType) {
        registeredDataAdapters.removeValue(forKey: requestId)
    }

    public func dataAdapterClass(for requestId: WOTRequestIdType) -> JSONAdapterProtocol.Type? {
        return registeredDataAdapters[requestId]
    }

    public func requestClass(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type? {
        return registeredRequests[requestId]
    }

    public func modelClass(forRequest request: WOTRequestProtocol) -> PrimaryKeypathProtocol.Type? {
        guard let clazz = type(of: request) as? WOTModelServiceProtocol.Type else { return nil }
        return clazz.modelClass()
    }

    public func modelClass(forRequestIdType requestIdType: WOTRequestIdType) -> PrimaryKeypathProtocol.Type? {
        guard let requestClass = registeredRequests[requestIdType] else {
            return nil
//            throw RequestCoordinatorError.requestClassNotFound(requestType: requestIdType.description)
        }

        return requestClass.modelClass()
    }
}

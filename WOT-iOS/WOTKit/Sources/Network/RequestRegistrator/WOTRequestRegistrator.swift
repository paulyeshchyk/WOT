//
//  WOTRequestRegistrator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTRequestRegistrator: WOTRequestRegistratorProtocol {
    public var appManager: WOTAppManagerProtocol?

    private var registeredRequests: [WOTRequestIdType: WOTModelServiceProtocol.Type] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: JSONAdapterProtocol.Type] = .init()

    public init() {
        //
    }
}

// MARK: - WOTRequestBindingProtocol

extension WOTRequestRegistrator {
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

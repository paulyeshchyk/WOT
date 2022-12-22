//
//  WOTRequestRegistrator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RequestRegistrator: RequestRegistratorProtocol {
    public typealias Context = LogInspectorContainerProtocol
    
    private let context: Context
    private var registeredRequests: [RequestIdType: WOTModelServiceProtocol.Type] = .init()
    private var registeredDataAdapters: [RequestIdType: JSONAdapterProtocol.Type] = .init()

    required public init(context: Context) {
        self.context = context
    }

}

// MARK: - WOTRequestBindingProtocol

extension RequestRegistrator {
    
    private enum RequestRegistratorError: Error {
        case requestClassNotFound(requestType: String)
    }
    
    public func requestIds(forClass: AnyClass) -> [RequestIdType] {
        let result = registeredRequests.keys.filter {
            forClass == registeredRequests[$0]?.modelClass()
        }
        return result
    }

    public func requestId(_ requiestId: RequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: JSONAdapterProtocol.Type) {
        registeredRequests[requiestId] = requestClass
        registeredDataAdapters[requiestId] = dataAdapterClass
    }

    public func unregisterDataAdapter(for requestId: RequestIdType) {
        registeredDataAdapters.removeValue(forKey: requestId)
    }

    public func dataAdapterClass(for requestId: RequestIdType) -> JSONAdapterProtocol.Type? {
        return registeredDataAdapters[requestId]
    }

    public func requestClass(for requestId: RequestIdType) -> WOTModelServiceProtocol.Type? {
        return registeredRequests[requestId]
    }

    public func modelClass(forRequest request: RequestProtocol) -> PrimaryKeypathProtocol.Type? {
        guard let clazz = type(of: request) as? WOTModelServiceProtocol.Type else { return nil }
        return clazz.modelClass()
    }

    public func modelClass(forRequestIdType requestIdType: RequestIdType) -> PrimaryKeypathProtocol.Type? {
        guard let requestClass = registeredRequests[requestIdType] else {
            return nil
//            throw RequestRegistratorError.requestClassNotFound(requestType: requestIdType.description)
        }

        return requestClass.modelClass()
    }
}

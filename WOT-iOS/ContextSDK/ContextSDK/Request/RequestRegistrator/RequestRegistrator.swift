//
//  WOTRequestRegistrator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RequestRegistrator: RequestRegistratorProtocol {
    public typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol
    
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
        case requestNotFound
        case requestClassNotFound(requestType: String)
        case requestClassHasNoModelClass(requestClass: String)
        case modelClassNotFound(RequestProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)

        public var description: String {
            switch self {
            case .requestNotFound: return "\(type(of: self)): Request not found"
            case .requestClassNotFound(let requestType): return "\(type(of: self)): Request Class not found for request type: \(requestType)"
            case .requestClassHasNoModelClass(let requestClass): return "\(type(of: self)): Request class(\(requestClass)) has no model class"
            case .modelClassNotFound(let request): return "\(type(of: self)): Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "\(type(of: self)): Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            }
        }
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
    
    public func requestIds(forRequest request: RequestProtocol) throws -> [RequestIdType] {
        guard let modelClass = modelClass(forRequest: request) else {
            throw RequestRegistratorError.modelClassNotFound(request)
        }

        let result = requestIds(forClass: modelClass)
        guard result.count > 0 else {
            throw RequestRegistratorError.modelClassNotRegistered(modelClass, request)
        }
        return result
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
    
    public func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol {
        guard let Clazz = requestClass(for: requestId) as? RequestProtocol.Type else {
            throw RequestRegistratorError.requestNotFound
        }
        return Clazz.init(context: context)
    }

    public func modelClass(forRequest request: RequestProtocol) -> PrimaryKeypathProtocol.Type? {
        guard let clazz = type(of: request) as? WOTModelServiceProtocol.Type else { return nil }
        return clazz.modelClass()
    }

    public func modelClass(forRequestIdType requestIdType: RequestIdType) throws -> PrimaryKeypathProtocol.Type {
        guard let requestClass = registeredRequests[requestIdType] else {
            throw RequestRegistratorError.requestClassNotFound(requestType: requestIdType.description)
        }
        guard let result = requestClass.modelClass() else {
            throw RequestRegistratorError.requestClassHasNoModelClass(requestClass: "\(type(of: requestClass))")
        }
        return result
    }
}

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
    private var registeredModelService: [RequestIdType: ModelServiceProtocol.Type] = .init()
    private var registeredModelClass: [RequestIdType: PrimaryKeypathProtocol.Type] = .init()

    public required init(appContext: Context) {
        context = appContext
    }
}

// MARK: - WOTRequestBindingProtocol

public extension RequestRegistrator {
    private enum RequestRegistratorError: Error, CustomStringConvertible {
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

    func requestIds(modelServiceClass: AnyClass) -> [RequestIdType] {
        registeredModelService.keys.filter {
            modelServiceClass == registeredModelClass[$0]
        }
    }

    func registerServiceClass(_ modelServiceClass: ModelServiceProtocol.Type) {
        let modelClass = modelServiceClass.modelClass()
        let registrationID = modelServiceClass.registrationID()
        registeredModelService[registrationID] = modelServiceClass
        registeredModelClass[registrationID] = modelClass
    }

    func requestClass(for requestId: RequestIdType) -> ModelServiceProtocol.Type? {
        return registeredModelService[requestId]
    }

    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol {
        guard let Clazz = requestClass(for: requestId) as? RequestProtocol.Type else {
            throw RequestRegistratorError.requestNotFound
        }
        return Clazz.init(context: context)
    }
}

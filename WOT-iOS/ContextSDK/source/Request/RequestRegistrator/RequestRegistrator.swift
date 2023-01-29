//
//  RequestRegistrator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestRegistrator

open class RequestRegistrator: RequestRegistratorProtocol {

    public typealias Context = LogInspectorContainerProtocol
        & HostConfigurationContainerProtocol

    private let appContext: Context
    private var registeredModelService: [RequestIdType: RequestModelServiceProtocol.Type] = .init()
    private var registeredModelClass: [RequestIdType: PrimaryKeypathProtocol.Type] = .init()

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
    }
}

// MARK: - WOTRequestBindingProtocol

public extension RequestRegistrator {

    func registerServiceClass(_ modelServiceClass: RequestModelServiceProtocol.Type) throws {
        let filtered = registeredModelService.keys.filter {
            modelServiceClass == registeredModelClass[$0]
        }
        guard filtered.isEmpty else {
            throw Errors.cantRegisterModelServiceClass(modelServiceClass)
        }
        let modelClass = modelServiceClass.modelClass()
        let registrationID = modelServiceClass.registrationID()
        registeredModelService[registrationID] = modelServiceClass
        registeredModelClass[registrationID] = modelClass
    }

    func createRequest(requestConfiguration: RequestConfigurationProtocol, decodingDepthLevel: DecodingDepthLevel?) throws -> RequestProtocol {
        //
        let request = try createRequest(forModelClass: requestConfiguration.modelClass)
        request.decodingDepthLevel = decodingDepthLevel
        request.arguments = try requestConfiguration.buildArguments(forRequest: request)

        return request
    }
}

extension RequestRegistrator {

    private func requestClass(for requestId: RequestIdType) -> RequestModelServiceProtocol.Type? {
        return registeredModelService[requestId]
    }

    private func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol {
        guard let Clazz = requestClass(for: requestId) as? RequestProtocol.Type else {
            throw Errors.requestNotFound
        }
        return Clazz.init(appContext: appContext)
    }

    private func requestId(forModelClass: ModelClassType) throws -> RequestIdType {
        let filtered = registeredModelService.keys.filter {
            forModelClass == registeredModelClass[$0]
        }
        guard let result = filtered.last else {
            throw Errors.requestNotFound
        }
        return result
    }

    private func createRequest(forModelClass: ModelClassType) throws -> RequestProtocol {
        let requestID = try requestId(forModelClass: forModelClass)
        return try createRequest(forRequestId: requestID)
    }

}

// MARK: - %t + RequestRegistrator.Errors

extension RequestRegistrator {
    enum Errors: Error, CustomStringConvertible {
        case requestNotFound
        case requestIdNotFound(RequestModelServiceProtocol.Type)
        case requestClassNotFound(requestType: String)
        case requestClassHasNoModelClass(requestClass: String)
        case modelClassNotFound(RequestProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)
        case cantRegisterModelServiceClass(RequestModelServiceProtocol.Type)

        public var description: String {
            switch self {
            case .requestNotFound: return "\(type(of: self)): Request not found"
            case .requestClassNotFound(let requestType): return "\(type(of: self)): Request Class not found for request type: \(requestType)"
            case .requestClassHasNoModelClass(let requestClass): return "\(type(of: self)): Request class(\(requestClass)) has no model class"
            case .modelClassNotFound(let request): return "\(type(of: self)): Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "\(type(of: self)): Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            case .cantRegisterModelServiceClass(let modelServiceClass): return "\(type(of: self)): Already registered (\(String(describing: modelServiceClass))"
            case .requestIdNotFound(let modelServiceClass): return "\(type(of: self)): Reguest id not found for (\(String(describing: modelServiceClass))"
            }
        }
    }

}

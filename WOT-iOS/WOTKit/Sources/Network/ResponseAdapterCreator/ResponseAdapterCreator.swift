//
//  WOTResponseAdapterCreator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class ResponseAdapterCreator: ResponseAdapterCreatorProtocol {
    
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestRegistratorContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    private enum ResponseAdapterCreatorError: Error, CustomStringConvertible {
        case adapterNotFound(requestType: RequestIdType)
        case modelClassNotFound(requestType: RequestIdType)
        var description: String {
            switch self {
            case .adapterNotFound(let requestType): return "\(type(of: self)): adapter not found \(requestType)"
            case .modelClassNotFound(let requestType): return "\(type(of: self)): model class not found \(requestType)"
            }
        }
    }
    
    private let context: Context

    public init(context: Context) {
        self.context = context
    }

    public func responseAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, adapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) throws -> JSONAdapterProtocol {
        
        guard let modelClass = try context.requestRegistrator?.modelClass(forRequestIdType: requestIdType) else {
            throw ResponseAdapterCreatorError.modelClassNotFound(requestType: requestIdType)
        }
        guard  let dataAdapterClass = context.requestRegistrator?.dataAdapterClass(for: requestIdType) else {
            throw ResponseAdapterCreatorError.adapterNotFound(requestType: requestIdType)
        }

        return dataAdapterClass.init(Clazz: modelClass, request: request, context: context, jsonAdapterLinker: adapterLinker)
    }

    public func responseAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, adapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) -> [DataAdapterProtocol] {
        var adapters: [DataAdapterProtocol] = .init()
        byRequestIdTypes.forEach { requestIdType in
            do {
                let adapter = try responseAdapterInstance(for: requestIdType, request: request, adapterLinker: adapterLinker, requestManager: requestManager)
                adapters.append(adapter)
            } catch {
                context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        return adapters
    }
}

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
    
    private let context: Context

    public init(context: Context) {
        self.context = context
    }

    public func responseAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) throws -> JSONAdapterProtocol {
        guard let modelClass = context.requestRegistrator?.modelClass(forRequestIdType: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType.description)
        }
        guard let dataAdapterClass = context.requestRegistrator?.dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType.description)
        }

        return dataAdapterClass.init(Clazz: modelClass, request: request, context: context, jsonAdapterLinker: jsonAdapterLinker)
    }

    public func responseAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) -> [DataAdapterProtocol] {
        var adapters: [DataAdapterProtocol] = .init()
        byRequestIdTypes.forEach { requestIdType in
            do {
                let adapter = try responseAdapterInstance(for: requestIdType, request: request, jsonAdapterLinker: jsonAdapterLinker, requestManager: requestManager)
                adapters.append(adapter)
            } catch {
                context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        return adapters
    }
}

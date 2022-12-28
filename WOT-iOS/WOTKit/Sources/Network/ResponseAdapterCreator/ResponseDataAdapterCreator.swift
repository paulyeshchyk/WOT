//
//  WOTResponseAdapterCreator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class ResponseDataAdapterCreator: ResponseDataAdapterCreatorProtocol {
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

    private let appContext: Context

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public func responseDataAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, managedObjectCreator: ManagedObjectCreatorProtocol) throws -> ResponseAdapterProtocol {
        guard let modelClass = try appContext.requestRegistrator?.modelClass(forRequestIdType: requestIdType) else {
            throw ResponseAdapterCreatorError.modelClassNotFound(requestType: requestIdType)
        }
        guard  let dataAdapterClass = appContext.requestRegistrator?.dataAdapterClass(for: requestIdType) else {
            throw ResponseAdapterCreatorError.adapterNotFound(requestType: requestIdType)
        }

        return dataAdapterClass.init(modelClass: modelClass, request: request, context: appContext, managedObjectCreator: managedObjectCreator)
    }

    public func responseDataAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, managedObjectCreator: ManagedObjectCreatorProtocol) -> [ResponseAdapterProtocol] {
        byRequestIdTypes.compactMap({ requestIdType in
            do {
                return try responseDataAdapterInstance(for: requestIdType, request: request, managedObjectCreator: managedObjectCreator)
            } catch {
                appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                return nil
            }
        })
    }
}

//
//  WOTResponseAdapterCreator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTResponseAdapterCreator: WOTResponseAdapterCreatorProtocol {
    public var logInspector: LogInspectorProtocol
    public var coreDataStore: WOTCoredataStoreProtocol
    public var decoderAndMapper: WOTDecodeAndMappingProtocol
    public var requestRegistrator: WOTRequestRegistratorProtocol

    public init(logInspector: LogInspectorProtocol, coreDataStore: WOTCoredataStoreProtocol, decoderAndMapper: WOTDecodeAndMappingProtocol, requestRegistrator: WOTRequestRegistratorProtocol) {
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
        self.decoderAndMapper = decoderAndMapper
        self.requestRegistrator = requestRegistrator
    }

    public func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol) throws -> JSONAdapterProtocol {
        guard let modelClass = requestRegistrator.modelClass(forRequestIdType: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType.description)
        }
        guard let dataAdapterClass = requestRegistrator.dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType.description)
        }

        return dataAdapterClass.init(Clazz: modelClass, request: request, logInspector: logInspector, coreDataStore: coreDataStore, linker: linker, decoderAndMapper: decoderAndMapper)
    }

    public func responseAdapterInstances(byRequestIdTypes: [WOTRequestIdType], request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol) -> [DataAdapterProtocol] {
        var adapters: [DataAdapterProtocol] = .init()
        byRequestIdTypes.forEach { requestIdType in
            do {
                let adapter = try self.responseAdapterInstance(for: requestIdType, request: request, linker: linker)
                adapters.append(adapter)
            } catch {
                logInspector.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        return adapters
    }
}

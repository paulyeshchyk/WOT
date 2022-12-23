//
//  ResponseAdapterCreatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//


public protocol ResponseAdapterCreatorContainerProtocol {
    var responseAdapterCreator: ResponseAdapterCreatorProtocol? { get set }
}

public protocol ResponseAdapterCreatorProtocol {
    func responseAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) throws -> JSONAdapterProtocol
    func responseAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, requestManager: RequestManagerProtocol) -> [DataAdapterProtocol]
}

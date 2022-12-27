//
//  ResponseAdapterCreatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseAdapterCreatorContainerProtocol {
    var responseAdapterCreator: ResponseAdapterCreatorProtocol? { get set }
}

@objc
public protocol ResponseAdapterCreatorProtocol {
    func responseAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, adapterLinker: AdapterLinkerProtocol, requestManager: RequestManagerProtocol) throws -> ResponseAdapterProtocol
    func responseAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, adapterLinker: AdapterLinkerProtocol, requestManager: RequestManagerProtocol) -> [ResponseAdapterProtocol]
}

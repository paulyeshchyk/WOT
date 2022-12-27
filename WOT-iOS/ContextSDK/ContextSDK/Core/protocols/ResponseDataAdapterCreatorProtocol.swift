//
//  ResponseAdapterCreatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseDataAdapterCreatorContainerProtocol {
    var responseDataAdapterCreator: ResponseDataAdapterCreatorProtocol? { get set }
}

@objc
public protocol ResponseDataAdapterCreatorProtocol {
    func responseDataAdapterInstance(for requestIdType: RequestIdType, request: RequestProtocol, managedObjectCreator: ManagedObjectCreatorProtocol) throws -> ResponseAdapterProtocol
    func responseDataAdapterInstances(byRequestIdTypes: [RequestIdType], request: RequestProtocol, managedObjectCreator: ManagedObjectCreatorProtocol) -> [ResponseAdapterProtocol]
}

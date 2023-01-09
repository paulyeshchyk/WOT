//
//  RequestManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

// MARK: - RequestManagerProtocol

@objc
public protocol RequestManagerProtocol {

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol)
    func removeListener(_ listener: RequestManagerListenerProtocol)
    func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectCreator: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws

    @available(*, deprecated, message: "fetchRemote should be used instead")
    func createRequest(forRequestId: RequestIdType) throws -> RequestProtocol

    @available(*, deprecated, message: "Syndicate to be used")
    func fetchRemote(requestParadigm: RequestParadigmProtocol, managedObjectLinker: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws
}

// MARK: - RequestManagerContainerProtocol

@objc
public protocol RequestManagerContainerProtocol {
    @objc var requestManager: RequestManagerProtocol? { get set }
}

// MARK: - RequestManagerListenerProtocol

@objc
public protocol RequestManagerListenerProtocol: MD5Protocol {
    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, error: Error?)
    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol)
    func requestManager(_ requestManager: RequestManagerProtocol, didCancelRequest: RequestProtocol, reason: RequestCancelReasonProtocol)
}

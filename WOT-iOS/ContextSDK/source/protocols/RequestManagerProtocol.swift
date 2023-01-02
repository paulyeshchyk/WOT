//
//  RequestManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

@objc
public protocol RequestManagerProtocol {
    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol)
    func removeListener(_ listener: RequestManagerListenerProtocol)
    func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectCreator: ManagedObjectLinkerProtocol, listener: RequestManagerListenerProtocol?) throws
    func fetchRemote(requestParadigm: RequestParadigmProtocol, linker: ManagedObjectLinkerProtocol, listener: RequestManagerListenerProtocol?) throws
    //
    @available(*, deprecated, message: "fetchRemote should be used instead")
    func createRequest(forRequestId: RequestIdType) throws -> RequestProtocol
}

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol RequestManagerContainerProtocol {
    @objc var requestManager: RequestManagerProtocol? { get set }
}

@objc
public protocol RequestManagerListenerProtocol: MD5Protocol {
    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)
    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol)
    func requestManager(_ requestManager: RequestManagerProtocol, didCancelRequest: RequestProtocol, reason: RequestCancelReasonProtocol)
}

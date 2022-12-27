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
    func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, adapterLinker: AdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws
    func fetchRemote(requestParadigm: RequestParadigmProtocol, requestPredicateComposer: RequestPredicateComposerProtocol, adapterLinker: AdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws
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
}


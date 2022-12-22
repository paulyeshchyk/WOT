//
//  RequestManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

@objc
public protocol WOTRequestCoordinatorBridgeProtocol {
    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol
}

@objc
public protocol RequestManagerProtocol: WOTRequestCoordinatorBridgeProtocol {
    //func addListener(_ listener: RequestManagerListenerProtocol?, forRequest: RequestProtocol)
    func removeListener(_ listener: RequestManagerListenerProtocol)
    func startRequest(_ request: RequestProtocol, withArguments arguments: RequestArgumentsProtocol, forGroupId: RequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws
    func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws
    func cancelRequests(groupId: RequestIdType, with error: Error?)
    func createRequest(forRequestId: RequestIdType) throws -> RequestProtocol
    func requestIds(forRequest request: RequestProtocol) -> [RequestIdType]
    func fetchRemote(paradigm: MappingParadigmProtocol)
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
public protocol RequestManagerListenerProtocol {
    var md5: String? { get }
    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)
    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol)
}


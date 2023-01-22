//
//  RequestManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

// MARK: - RequestManagerProtocol

@objc
public protocol RequestManagerProtocol {

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    func startRequest(_ request: RequestProtocol, listener: RequestManagerListenerProtocol?) throws

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol)

    func removeListener(_ listener: RequestManagerListenerProtocol)
}

// MARK: - RequestManagerContainerProtocol

@objc
public protocol RequestManagerContainerProtocol {
    var requestManager: RequestManagerProtocol? { get set }
}

// MARK: - RequestManagerListenerProtocol

@objc
public protocol RequestManagerListenerProtocol: MD5Protocol {
    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, error: Error?)
    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol)
    func requestManager(_ requestManager: RequestManagerProtocol, didCancelRequest: RequestProtocol, reason: RequestCancelReasonProtocol)
}

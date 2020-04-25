//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestProtocol: WOTStartableProtocol, WOTDescribable {
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }

    @objc
    var listeners: [WOTRequestListenerProtocol] { get }

    @objc
    func addListener(_ listener: WOTRequestListenerProtocol)

    @objc
    func removeListener(_ listener: WOTRequestListenerProtocol)

    @objc
    var availableInGroups: [String] { get }

    @objc
    func addGroup(_ group: String)

    @objc
    func removeGroup(_ group: String)

    var uuid: UUID { get }

    var parentRequest: WOTRequestProtocol? { get set }
}

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol WOTRequestManagerListenerProtocol {
    @objc
    var uuidHash: Int { get }

    @objc
    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: WOTRequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)

    @objc
    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: WOTRequestProtocol)
}

@objc
public protocol WOTRequestManagerProtocol {
    @objc
    @discardableResult
    func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String, jsonLink: WOTJSONLink?, externalCallback: NSManagedObjectCallback?) -> Bool

    @objc
    func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol?

    @objc
    func addListener(_ listener: WOTRequestManagerListenerProtocol?, forRequest: WOTRequestProtocol)

    @objc
    func removeListener(_ listener: WOTRequestManagerListenerProtocol)

    @objc
    func cancelRequests(groupId: String)

    @objc
    var hostConfiguration: WOTHostConfigurationProtocol { get set }

    @objc
    var appManager: WOTAppManagerProtocol? { get set }

    @objc
    var coordinator: WOTRequestCoordinatorProtocol { get }

    @objc
    @discardableResult
    func queue(parentRequest: WOTRequestProtocol?, requestId: WOTRequestIdType, jsonLink: WOTJSONLink, externalCallback: NSManagedObjectCallback?, listener: WOTRequestManagerListenerProtocol?) -> Bool
}

public extension WOTRequestManagerProtocol {}

@objc
public protocol WOTRequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc
    func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?)

    @objc
    func requestHasCanceled(_ request: WOTRequestProtocol)

    @objc
    func requestHasStarted(_ request: WOTRequestProtocol)

    @objc
    func removeRequest(_ request: WOTRequestProtocol)
}

@objc
public protocol WOTStartableProtocol {
    @objc
    func cancel()

    @objc
    @discardableResult
    func start(_ args: WOTRequestArgumentsProtocol) -> Bool
}

@objc
open class WOTRequest: NSObject, WOTRequestProtocol, WOTStartableProtocol {
    public let uuid: UUID = UUID()

    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc
    public var availableInGroups = [String]()

    @objc
    public var listeners = [WOTRequestListenerProtocol]()

    private var groups = [String]()

    @objc
    open func addGroup(_ group: String) {
        groups.append(group)
    }

    @objc
    open func removeGroup(_ group: String) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    @objc
    open func addListener(_ listener: WOTRequestListenerProtocol) {
        listeners.append(listener)
    }

    @objc
    open func removeListener(_ listener: WOTRequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { (obj) -> Bool in
            return (obj.hash == listener.hash)
        }) {
            listeners.remove(at: index)
        }
    }

    override open var hash: Int {
        return NSStringFromClass(type(of: self)).hash
    }

    @objc
    open func cancel() {}

    @objc
    @discardableResult
    open func start(_ args: WOTRequestArgumentsProtocol) -> Bool { return false }

    @objc
    public var parentRequest: WOTRequestProtocol?
}

//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestProtocol: WOTStartableProtocol, Describable {
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
    func addGroup(_ group: WOTRequestIdType)

    @objc
    func removeGroup(_ group: String)

    var uuid: UUID { get }

    @objc
    var predicate: WOTPredicate? { get set }
}

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol WOTRequestManagerListenerProtocol {
    var uuidHash: Int { get }

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: WOTRequestProtocol, completionResultType: WOTRequestManagerCompletionResultType, error: Error?)

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: WOTRequestProtocol)
}

@objc
public protocol WOTRequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: WOTRequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: WOTRequestProtocol, startedWith hostConfiguration: WOTHostConfigurationProtocol, args: WOTRequestArgumentsProtocol)
}

@objc
public protocol WOTStartableProtocol {
    func cancel(with error: Error?)
    func start(withArguments: WOTRequestArgumentsProtocol) throws
}

@objc
open class WOTRequest: NSObject, WOTRequestProtocol {
    public let uuid: UUID = UUID()

    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc
    public var availableInGroups = [WOTRequestIdType]()

    @objc
    public var listeners = [WOTRequestListenerProtocol]()

    public var predicate: WOTPredicate?

    private var groups = [WOTRequestIdType]()

    @objc
    open func addGroup(_ group: WOTRequestIdType) {
        groups.append(group)
    }

    @objc
    open func removeGroup(_ group: WOTRequestIdType) {
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

    open func cancel(with error: Error?) {}

    open func start(withArguments: WOTRequestArgumentsProtocol) throws { throw LogicError.shouldBeOverriden}
}

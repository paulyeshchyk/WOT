//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias RequestIdType = NSInteger

// MARK: - RequestProtocol

@objc
public protocol RequestProtocol: StartableProtocol, MD5Protocol {
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol

    var availableInGroups: [RequestIdType] { get }
    var listeners: [RequestListenerProtocol] { get }
    var contextPredicate: ContextPredicateProtocol? { get set }
    var arguments: RequestArgumentsProtocol? { get set }

    func addGroup(_ group: RequestIdType)
    func addListener(_ listener: RequestListenerProtocol)
    func removeGroup(_ group: RequestIdType)
    func removeListener(_ listener: RequestListenerProtocol)
    init(context: Context)
}

// MARK: - RequestListenerContainerProtocol

@objc
public protocol RequestListenerContainerProtocol {
    @objc var requestListener: RequestListenerProtocol? { get set }
}

// MARK: - RequestListenerProtocol

@objc
public protocol RequestListenerProtocol: MD5Protocol {
    @objc func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: RequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: RequestProtocol, startedWith urlRequest: URLRequest)
}

// MARK: - Request

open class Request: RequestProtocol, CustomStringConvertible {

    public required init(context: RequestProtocol.Context) {
        appContext = context
        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        appContext.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    open var description: String {
        var result = [AnyHashable: Any]()
        if let arguments = arguments {
            result["\(type(of: self))"] = String(describing: arguments)
        } else {
            result["\(type(of: self))"] = ""
        }
        let str = result.debugOutput()
        return str as String
    }

    open func addGroup(_ group: RequestIdType) {
        availableInGroups.append(group)
    }

    open func addListener(_ listener: RequestListenerProtocol) {
        listeners.append(listener)
    }

    open func removeGroup(_ group: RequestIdType) {
        availableInGroups.removeAll(where: { group == $0 })
    }

    open func removeListener(_ listener: RequestListenerProtocol) {
        listeners.removeAll(where: { $0.MD5 == listener.MD5 })
    }

    public let appContext: RequestProtocol.Context

    // MARK: - RequestProtocol

    public var availableInGroups = [RequestIdType]()

    public var listeners = [RequestListenerProtocol]()

    public var contextPredicate: ContextPredicateProtocol?

    public var arguments: RequestArgumentsProtocol?

    public var MD5: String { uuid.MD5 }

    // MARK: - MD5Protocol

    private let uuid = UUID()

}

extension Request {
    // MARK: - StartableProtocol

    open func cancel(byReason _: RequestCancelReasonProtocol) throws {
        throw RequestError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    open func start(completion _: @escaping (() -> Void)) throws {
        throw RequestError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}

// MARK: - RequestError

private enum RequestError: Error, CustomStringConvertible {
    case shouldBeOverriden(String)

    var description: String {
        switch self {
        case .shouldBeOverriden(let text): return "\(type(of: self)): '\(text)' should be overridden"
        }
    }
}

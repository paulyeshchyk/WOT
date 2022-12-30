//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias RequestIdType = NSInteger

@objc
public protocol RequestProtocol: StartableProtocol, MD5Protocol {
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol

    var availableInGroups: [RequestIdType] { get }
    var listeners: [RequestListenerProtocol] { get }
    var contextPredicate: ContextPredicate? { get set }
    var arguments: RequestArgumentsProtocol? { get set }

    func addGroup(_ group: RequestIdType)
    func addListener(_ listener: RequestListenerProtocol)
    func removeGroup(_ group: RequestIdType)
    func removeListener(_ listener: RequestListenerProtocol)
    init(context: Context)
}

@objc
public protocol RequestListenerContainerProtocol {
    @objc var requestListener: RequestListenerProtocol? { get set }
}

@objc
public protocol RequestListenerProtocol: MD5Protocol {
    @objc func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: RequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: RequestProtocol, startedWith urlRequest: URLRequest)
}

open class Request: RequestProtocol, CustomStringConvertible {
    // MARK: - MD5Protocol
    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    // MARK: - Public

    public let appContext: RequestProtocol.Context

    open var description: String {
        if let arguments = arguments {
            return "\(type(of: self)): \(String(describing: arguments))"
        } else {
            return "\(type(of: self))"
        }
    }

    public required init(context: RequestProtocol.Context) {
        self.appContext = context
        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        appContext.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    // MARK: - RequestProtocol

    public var availableInGroups = [RequestIdType]()

    public var listeners = [RequestListenerProtocol]()

    public var contextPredicate: ContextPredicate?

    public var arguments: RequestArgumentsProtocol?

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
        listeners.removeAll(where: {$0.MD5 == listener.MD5 })
    }
}

extension Request {
    // MARK: - StartableProtocol
    open func cancel(byReason: RequestCancelReasonProtocol) throws {
        throw RequestError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    open func start(completion: @escaping (() -> Void)) throws {
        throw RequestError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}

private enum RequestError: Error, CustomStringConvertible {
    case shouldBeOverriden(String)
    var description: String {
        switch self {
        case .shouldBeOverriden(let text): return "\(type(of: self)): '\(text)' should be overridden"
        }
    }
}

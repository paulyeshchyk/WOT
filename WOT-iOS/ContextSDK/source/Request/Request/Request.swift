//
//  Request.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - Request

open class Request: RequestProtocol, CustomStringConvertible {

    open var description: String {
        if let arguments = arguments {
            return "\(type(of: self)): \(String(describing: arguments))"
        } else {
            return "\(type(of: self))"
        }
    }

    public var decodingDepthLevel: DecodingDepthLevel?

    let appContext: Context

    // MARK: - RequestProtocol

    public var availableInGroups = [RequestIdType]()

    public var listeners = [RequestListenerProtocol]()

    public var contextPredicate: ContextPredicateProtocol? {
        arguments?.contextPredicate
    }

    public var arguments: RequestArgumentsProtocol? {
        didSet {
            //
        }
    }

    public var MD5: String { uuid.MD5 }
    public var completion: ((Data?, Error?) -> Void)?

    // MARK: to be moved out from interface

    open var httpQueryItemName: String? { nil }
    open func httpAPIQueryPrefix() -> String? { nil }

    // MARK: - MD5Protocol

    private let uuid = UUID()

    // MARK: Lifecycle

    public required init(appContext: RequestProtocol.Context) {
        self.appContext = appContext
        self.appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
        decodingDepthLevel = DecodingDepthLevel.limited(by: .custom(2))
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    // MARK: Open

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
}

extension Request {
    // MARK: - StartableProtocol

    open func cancel(byReason _: RequestCancelReasonProtocol) throws {
        throw RequestError.hasNotBeenImplemented("\(type(of: self))::\(#function)")
    }

    open func start() throws {
        throw RequestError.hasNotBeenImplemented("\(type(of: self))::\(#function)")
    }
}

// MARK: - RequestError

private enum RequestError: Error, CustomStringConvertible {
    case hasNotBeenImplemented(String)

    var description: String {
        switch self {
        case .hasNotBeenImplemented(let text): return "\(type(of: self)): '\(text)' has not been implemented"
        }
    }
}

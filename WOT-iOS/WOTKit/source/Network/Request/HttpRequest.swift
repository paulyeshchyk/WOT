//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - HttpRequestProtocol

public protocol HttpRequestProtocol {}

// MARK: - HttpRequest

open class HttpRequest: Request, HttpRequestProtocol {

    override public var description: String {
        "\(type(of: self)): \(path)"
    }

    private var httpDataReceiver: HttpDataReceiver?

    override open var httpQueryItemName: String {
        fatalError("has not been implemented")
    }

    // MARK: Lifecycle

    deinit {
        httpDataReceiver?.delegate = nil
        httpDataReceiver?.cancel()
    }

    // MARK: Open

    override open func cancel(byReason: RequestCancelReasonProtocol) throws {
        if httpDataReceiver?.cancel() ?? false {
            appContext.logInspector?.logEvent(HttpRequestCancelEvent(reason: byReason), sender: self)
        }
    }

    override open func start() throws {
        let urlRequest = try HttpRequestBuilder().build(hostConfiguration: appContext.hostConfiguration,
                                                        httpMethod: httpMethod,
                                                        path: path,
                                                        args: arguments,
                                                        bodyData: httpBodyData)

        httpDataReceiver = HttpDataReceiver(context: appContext, request: urlRequest)
        httpDataReceiver?.delegate = self
        httpDataReceiver?.start()
    }
}

// MARK: - HttpRequest + HttpDataReceiverDelegateProtocol

extension HttpRequest: HttpDataReceiverDelegateProtocol {
    public func didCancel(urlRequest _: URLRequest, receiver _: HttpDataReceiverProtocol, error: Error?) {
        for listener in listeners {
            listener.request(self, canceledWith: error)
        }
    }

    public func didStart(urlRequest: URLRequest, receiver _: HttpDataReceiverProtocol) {
        for listener in listeners {
            listener.request(self, startedWith: urlRequest)
        }
    }

    public func didEnd(urlRequest _: URLRequest, receiver _: HttpDataReceiverProtocol, data: Data?, error: Error?) {
        for listener in listeners {
            listener.request(self, finishedLoadData: data, error: error)
        }
        httpDataReceiver?.delegate = nil
    }
}

// MARK: - HttpRequest + HttpServiceProtocol

extension HttpRequest: HttpServiceProtocol {
    open var httpMethod: ContextSDK.HTTPMethod { return .POST }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }
    open var httpBodyData: Data? { nil }
}

// MARK: - HttpRequestCancelEvent

final private class HttpRequestCancelEvent: LogEventProtocol {

    var eventType: LogEventType { .info }
    var message: String { reason.reasonDescription }
    var name: String { "HttpRequestCancelEvent" }

    private let reason: RequestCancelReasonProtocol

    // MARK: Lifecycle

    init(reason: RequestCancelReasonProtocol) {
        self.reason = reason
    }
}

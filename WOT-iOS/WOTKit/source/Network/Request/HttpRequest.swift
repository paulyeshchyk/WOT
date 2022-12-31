//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class HttpRequest: Request {
    override public var description: String {
        "\(type(of: self)): \(path)"
    }

    private var httpDataReceiver: HttpDataReceiver?

    deinit {
        httpDataReceiver?.delegate = nil
        httpDataReceiver?.cancel()
    }

    override open func cancel(byReason: RequestCancelReasonProtocol) throws {
        if httpDataReceiver?.cancel() ?? false {
            appContext.logInspector?.logEvent(HttpRequestCancelEvent(reason: byReason), sender: self)
        }
    }

    override open func start(completion: @escaping (() -> Void)) throws {
        let urlRequest = try HttpRequestBuilder().build(hostConfiguration: appContext.hostConfiguration,
                                                        httpMethod: httpMethod,
                                                        path: path,
                                                        args: arguments,
                                                        bodyData: httpBodyData)

        httpDataReceiver = HttpDataReceiver(context: appContext, request: urlRequest)
        httpDataReceiver?.delegate = self
        httpDataReceiver?.start(completion: completion)
    }
}

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

// MARK: - WOTWebServiceProtocol

extension HttpRequest: HttpServiceProtocol {
    open var httpMethod: ContextSDK.HTTPMethod { return .POST }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }
    open var httpBodyData: Data? { nil }
}

private class HttpRequestCancelEvent: LogEventProtocol {
    var eventType: LogEventType { .info }
    var message: String { reason.reasonDescription }
    var name: String { "HttpRequestCancelEvent" }

    private let reason: RequestCancelReasonProtocol
    init(reason: RequestCancelReasonProtocol) {
        self.reason = reason
    }
}
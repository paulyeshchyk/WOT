//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class HttpRequest: Request {

    private class HttpRequestCancelEvent: LogEventProtocol {
        var eventType: LogEventType { .info }
        var message: String { reason.reasonDescription }
        var name: String { "HttpRequestCancelEvent" }
        
        private let reason: RequestCancelReasonProtocol
        init(reason: RequestCancelReasonProtocol) {
            self.reason = reason
        }
    }
    
    override open var description: String { "\(type(of: self)): \(httpDataReceiver?.description ?? "?")" }

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

extension HttpRequest: HttpDataReceiverDelegateProtocol {
    public func didCancel(urlRequest: URLRequest, receiver: HttpDataReceiverProtocol, error: Error?) {
        for listener in listeners {
            listener.request(self, canceledWith: error)
        }
    }
    
    public func didStart(urlRequest: URLRequest, receiver: HttpDataReceiverProtocol) {
        for listener in listeners {
            listener.request(self, startedWith: urlRequest)
        }
    }
    
    public func didEnd(urlRequest: URLRequest, receiver: HttpDataReceiverProtocol, data: Data?, error: Error?) {
        for listener in listeners {
            listener.request(self, finishedLoadData: data, error: error)
        }
        self.httpDataReceiver?.delegate = nil
    }
}


// MARK: - WOTWebServiceProtocol

extension HttpRequest: HttpServiceProtocol {
    open var httpMethod: ContextSDK.HTTPMethod { return .POST }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }
    open var httpBodyData: Data? { nil }
}

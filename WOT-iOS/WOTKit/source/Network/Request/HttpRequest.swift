//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - HttpRequest

open class HttpRequest: Request {

    deinit {
        httpDataReceiver?.delegate = nil
        httpDataReceiver?.cancel()
    }

    override open var description: String {
        var result = super.description
        if let httpDataReceiver = httpDataReceiver {
            result += "; \(httpDataReceiver.description)"
        }
        return result
    }

    override open func cancel(byReason _: RequestCancelReasonProtocol) throws {
        httpDataReceiver?.cancel()
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

    private var httpDataReceiver: HttpDataReceiver?
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

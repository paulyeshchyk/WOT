//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class HttpRequest: Request {

    override open var description: String { "\(type(of: self)): \(httpDataReceiver?.description ?? "?")" }

    private var httpDataReceiver: HttpDataReceiver?
    
    deinit {
        self.httpDataReceiver?.delegate = nil
    }
    
    override open func cancel(with error: Error?) {
        for listener in listeners {
            listener.request(self, canceledWith: error)
        }
    }

    override open func start(withArguments args: RequestArgumentsProtocol) throws {
        
        let urlRequest = try HttpRequestBuilder().build(hostConfiguration: context.hostConfiguration,
                                                        httpMethod: httpMethod,
                                                        path: path,
                                                        args: args,
                                                        bodyData: httpBodyData)
        
        httpDataReceiver = HttpDataReceiver(context: context, request: urlRequest)
        httpDataReceiver?.delegate = self
        httpDataReceiver?.start()
    }
}

extension HttpRequest: HttpDataReceiverDelegateProtocol {
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

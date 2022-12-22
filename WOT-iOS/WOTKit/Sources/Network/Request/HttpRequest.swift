//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class HttpRequest: Request {

    public var httpBodyData: Data?

    override open var description: String {
        let pumperDescription: String
        if let pumper = httpDataReceiver {
            pumperDescription = String(describing: pumper)
        } else {
            pumperDescription = ""
        }

        return "\(String(describing: type(of: self))) \(pumperDescription)"
    }

    override open var hash: Int {
        return (httpDataReceiver as? NSObject)?.hash ?? path.hashValue
    }

    deinit {
        self.httpDataReceiver?.delegate = nil
    }
    
    override open func cancel(with error: Error?) {
        for listener in listeners {
            listener.request(self, canceledWith: error)
        }
    }

    private var httpDataReceiver: HttpDataReceiverProtocol?
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
    public func didStart(receiver: HttpDataReceiverProtocol) {
        for listener in listeners {
            listener.request(self, startedWith: self.context.hostConfiguration)
        }
    }
    
    public func didEnd(receiver: HttpDataReceiverProtocol, data: Data?, error: Error?) {
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
}

//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebRequestProtocol {
//    func parse(data: Data?)
}

@objc(WOTWebServiceProtocol)
public protocol WOTWebServiceProtocol {
    var method: String { get }
    var path: String { get }
    func notifyListenersAboutStart()
    func requestHasFinishedLoad(data: Data?, error: Error?, invokedBy: WOTNestedRequestsEvaluatorProtocol)
}

@objc(WOTModelServiceProtocol)
public protocol WOTModelServiceProtocol: class {

    @objc
    static func modelClass() -> AnyClass?
    
    @objc
    func instanceModelClass() -> AnyClass?
}

@objc
open class WOTWEBRequest: WOTRequest, WOTWebServiceProtocol, NSURLConnectionDataDelegate {

    public var userInfo: [AnyHashable: Any]?
    public var httpBodyData: Data?

    open var method: String { return "POST" }
    open var path: String { return ""}

    public func notifyListenersAboutStart() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasStarted(self)
        }
    }

    public func requestHasFinishedLoad(data: Data?, error: Error?, invokedBy: WOTNestedRequestsEvaluatorProtocol) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, finishedLoadData: data, error: error, invokedBy: invokedBy)
        }
    }
    
    open override func cancel() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasCanceled(self)
        }
    }
    
    open func urlRequest(with args: WOTRequestArguments) -> URLRequest {

        let requestBuilder = WOTWebRequestBuilder()
        return requestBuilder.build(service: self, hostConfiguration: hostConfiguration, args: args, bodyData: httpBodyData)
    }

    @discardableResult
    open override func start(_ args: WOTRequestArguments?, invokedBy: WOTNestedRequestsEvaluatorProtocol) -> Bool {

        guard let args = args else {
            return false
        }
        
        invoker = invokedBy
        
        let request = urlRequest(with: args)
        let pumper = WOTWebDataPumper(request: request) {[weak self] (data, error) in

            self?.requestHasFinishedLoad(data: data, error: error, invokedBy: invokedBy)
        }
        
        pumper.start()
        self.notifyListenersAboutStart()
        return true
    }
}

class WOTWebRequestBuilder {

    private func buildURL(path: String, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArguments, bodyData: Data?) -> URL {

        let urlQuery: String? = hostConfiguration?.urlQuery(with: args)
        
        var components = URLComponents()
        components.scheme = hostConfiguration?.scheme
        components.host = hostConfiguration?.host
        components.path = path
        if bodyData == nil {
            components.query = urlQuery
        }
        guard let result = components.url else {
            fatalError("url not created")
        }
        return result

    }

    public func build(service: WOTWebServiceProtocol, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArguments, bodyData: Data?) -> URLRequest {
        let url = buildURL(path: service.path, hostConfiguration: hostConfiguration, args: args, bodyData: bodyData)

        var result = URLRequest(url: url)
        result.httpBody = bodyData
        result.timeoutInterval = 0
        result.httpMethod = service.method
        return result
    }
}

class WOTWebDataPumper: NSObject, NSURLConnectionDataDelegate {
    
    let request: URLRequest
    let completion: ((Data?, Error?) -> Void)
    private var data: Data?
    private var connection: NSURLConnection?
    
    required init(request: URLRequest, completion: (@escaping (Data?, Error?) -> Void) ) {
        
        self.request = request
        self.completion = completion
        
        super.init()
        
        connection = NSURLConnection(request: request, delegate: self)
    }
    
    public func start() {
        DispatchQueue.global().sync {
            connection?.start()
        }
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        
        self.data = Data()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        
        self.data?.append(data)
    }

    func connectionDidFinishLoading(_ connection: NSURLConnection) {

        completion(self.data, nil)
    }

    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {

        completion(nil, error)
    }
}

extension WOTWEBRequest: WOTWebRequestProtocol {
    
}

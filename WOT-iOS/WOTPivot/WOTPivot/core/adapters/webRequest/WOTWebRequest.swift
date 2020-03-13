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
    func requestHasFinishedLoad(data: Data?, error: Error?)
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

    private var completeHash: Int = 0
    override open var hash: Int {
        return completeHash
    }

    public func notifyListenersAboutStart() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasStarted(self)
        }
    }

    public func requestHasFinishedLoad(data: Data?, error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, finishedLoadData: data, error: error)
        }
    }
    
    open override func cancel() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasCanceled(self)
        }
    }
    
    open func urlRequest(with args: WOTRequestArgumentsProtocol) -> URLRequest {

        let requestBuilder = WOTWebRequestBuilder()
        return requestBuilder.build(service: self, hostConfiguration: hostConfiguration, args: args, bodyData: httpBodyData)
    }

    @discardableResult
    open override func start(_ args: WOTRequestArgumentsProtocol) -> Bool {

        let request = urlRequest(with: args)
        let pumper = WOTWebDataPumper(request: request) {[weak self] (data, error) in

            self?.requestHasFinishedLoad(data: data, error: error)
            print("ended request:\(request.url?.absoluteString ?? "??")")
        }
        
        completeHash = request.hashValue
        print("started request:\(request.url?.absoluteString ?? "??")")
        
        pumper.start()
        self.notifyListenersAboutStart()
        return true
    }
}

class WOTWebRequestBuilder {

    private func buildURL(path: String, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArgumentsProtocol, bodyData: Data?) -> URL {

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

    public func build(service: WOTWebServiceProtocol, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArgumentsProtocol, bodyData: Data?) -> URLRequest {
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
    
    deinit {
        print("deinit WOTWebDataPumper")
    }
    
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

        DispatchQueue.main.async { [weak self] in
            self?.completion(self?.data, nil)
        }
    }

    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {

        DispatchQueue.main.async { [weak self] in
            self?.completion(nil, error)
        }
    }
}

extension WOTWEBRequest: WOTWebRequestProtocol {
    
}

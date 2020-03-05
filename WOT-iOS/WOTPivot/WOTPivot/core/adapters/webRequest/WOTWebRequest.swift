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
    func parse(data: Data?)
}

@objc protocol WOTWebServiceProtocol {
    var method: String { get }
    var path: String { get }
    var uniqueDescription: String? { get }
    func notifyListenersAboutStart()
    func requestHasFinishedLoadData(error: Error?)
}

@objc
open class WOTWEBRequest: WOTRequest, WOTWebServiceProtocol, NSURLConnectionDataDelegate {

    @objc
    public var uniqueDescription: String? = nil

    public var userInfo: [AnyHashable: Any]?
    public var httpBodyData: Data?
    

    open class var modelClassName: String { return "" }
    open var method: String { return "POST" }
    open var path: String { return ""}


    public func notifyListenersAboutStart() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasStarted(self)
        }
    }

    public func requestHasFinishedLoadData(error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasFinishedLoadData(self, error: error)
        }
    }
    
    open override func cancel() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasCanceled(self)
        }
    }

    open override func start(_ args: WOTRequestArguments) {

        let requestBuilder = WOTWebRequestBuilder()
        let request = requestBuilder.build(path: path, hostConfiguration: hostConfiguration, args: args, bodyData: httpBodyData, method: method)
        let pumper = WOTWebDataPumper(request: request) {[weak self] (data, error) in
            guard let self = self else { return }
            
            self.parse(data: data)

            self.requestHasFinishedLoadData(error: error)
        }
        
        pumper.start()
        self.notifyListenersAboutStart()
    }
    
    @objc
    open override func cancelAndRemoveFromQueue() {
        self.cancel()
    }

}

class WOTWebRequestBuilder {

    private func buildURL(path: String, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArguments, bodyData: Data?) -> URL {
        var components = URLComponents()
        components.scheme = hostConfiguration?.scheme
        components.host = hostConfiguration?.host
        components.path = path
        if bodyData == nil {
            components.query = args.buildQuery()
        }
        guard let result = components.url else {
            fatalError("url not created")
        }
        return result

    }

    public func build(path: String, hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArguments, bodyData: Data?, method: String) -> URLRequest {
        let url = buildURL(path: path, hostConfiguration: hostConfiguration, args: args, bodyData: bodyData)

        var result = URLRequest(url: url)
        result.httpBody = bodyData
        result.timeoutInterval = 0
        result.httpMethod = method
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
    
    struct WOTWEBRequestError: Error {

        enum ErrorKind {
            case dataIsNull
            case emptyJSON
            case invalidStatus
            case parseError
        }
        
        let kind: ErrorKind
    }
    
    public func parse(data: Data?) {
        
        var mutableData: JSON = .init()
        let error = json(from: data) { (json) in
            mutableData.append(with: self.userInfo ?? [:])
            mutableData.append(with: json ?? [:])
        }
        
        self.requestHasFinishedLoadData(error: nil)
        self.callback?(mutableData, error, data)
    }
    
    private func json(from data: Data?, completion: ( ( JSON? ) -> Void )? ) -> Error? {

        guard let data = data else {
            return WOTWEBRequestError(kind: .dataIsNull)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves, .mutableContainers])
            guard let json = jsonObject as? JSON else {
                return WOTWEBRequestError(kind: .emptyJSON)
            }
            
            let response = WOTWebResponse()
            response.mapping(fromJSON: json)
            switch response.status {
            case .ok: completion?(response.data)
            default: return WOTWEBRequestError(kind: .invalidStatus)
            }
        } catch {
            return WOTWEBRequestError(kind: .parseError)
        }
        
        return nil
    }
}

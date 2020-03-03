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

@objc
open class WOTWEBRequest: WOTRequest, NSURLConnectionDataDelegate {

    @objc
    open class var instanceClassName: String { fatalError("shouldBeOverriden") }
    open var method: String { fatalError("shouldBeOverriden") }
    open var path: String { fatalError("shouldBeOverriden") }
    open var query: [AnyHashable: Any] { fatalError("shouldBeOverriden")}
    public var uniqueDescription: String { fatalError("shouldBeOverriden") }

    public var userInfo: [AnyHashable: Any]?
    public var httpBodyData: Data?
    

    public func notifyListenersAboutStart() {
        self.listeners.compactMap { $0 as? WOTRequestListener}.forEach {
            $0.requestHasStarted(self)
        }
    }

    public func requestHasFinishedLoadData(error: Error?) {
        self.listeners.compactMap { $0 as? WOTRequestListener}.forEach {
            $0.requestHasFinishedLoadData(self, error: error)
        }
    }
    
    public override func cancel() {
        self.listeners.compactMap { $0 as? WOTRequestListener}.forEach {
            $0.requestHasCanceled(self)
        }
    }

    override public func start(_ args: WOTRequestArguments) {
        super.start(args)

        let requestBuilder = WOTWebRequestBuilder()
        let request = requestBuilder.build(path: path, hostConfiguration: hostConfiguration, queryItems: query, bodyData: httpBodyData, method: method)
        let pumper = WOTWebDataPumper(request: request) {[weak self] (data, error) in
            guard let self = self else { return }
            
            self.parse(data: data)

            self.requestHasFinishedLoadData(error: error)
        }
        
        pumper.start()
        self.notifyListenersAboutStart()
    }
}


class WOTWebRequestBuilder {

    private func queryIntoString(queryItems: [AnyHashable: Any]) -> String {
        var queryArgs = [String]()
        queryItems.keys.compactMap{$0 as? String }.forEach {
            if let arg = $0.urlEncoded(), let value = queryItems[$0] as? String  {
                let queryArg = String(format:"%@=%@", arg, value)
                queryArgs.append(queryArg)
            }
        }
        return queryArgs.joined(separator: "&")
    }

    private func buildURL(path: String, hostConfiguration: WEBHostConfiguration, queryItems:[AnyHashable: Any], bodyData: Data?) -> URL {
        var components = URLComponents()
        components.scheme = hostConfiguration.scheme
        components.host = hostConfiguration.host
        components.path = path
        if bodyData == nil {
            components.query = queryIntoString(queryItems: queryItems)
        }
        guard let result = components.url else {
            fatalError("url not created")
        }
        return result

    }

    public func build(path: String, hostConfiguration: WEBHostConfiguration, queryItems:[AnyHashable: Any], bodyData: Data?, method: String) -> URLRequest {
        let url = buildURL(path: path, hostConfiguration: hostConfiguration, queryItems: queryItems, bodyData: bodyData)

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
        
        connection?.start()
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

extension WOTWEBRequest {
    @objc
    public override func cancelAndRemoveFromQueue() {
        self.cancel()
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
        WOTRequestExecutor.sharedInstance()?.removeRequest(self)
        self.callback(mutableData, error, data)
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

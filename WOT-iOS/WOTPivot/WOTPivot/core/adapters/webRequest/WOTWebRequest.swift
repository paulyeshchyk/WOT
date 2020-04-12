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

@objc
public protocol WOTWebServiceProtocol {
    var method: String { get }
    var path: String { get }
    func requestHasFinishedLoad(data: Data?, error: Error?)
}

@objc
public protocol WOTModelServiceProtocol: class {
    @objc
    static func modelClass() -> AnyClass?

    @objc
    func instanceModelClass() -> AnyClass?
}

@objc
open class WOTWEBRequest: WOTRequest, WOTWebServiceProtocol, NSURLConnectionDataDelegate {
    override open var description: String {
        return pumper?.description ?? "-"
    }

    public var userInfo: [AnyHashable: Any]?
    public var httpBodyData: Data?

    open var method: String { return "POST" }
    open var path: String { return "" }

    override open var hash: Int {
        return (pumper as? NSObject)?.hash ?? 0
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

    var pumper: WOTWebDataPumperProtocol?

    @discardableResult
    open override func start(_ args: WOTRequestArgumentsProtocol) -> Bool {
        self.pumper = WOTWebDataPumper(hostConfiguration: hostConfiguration, args: args, httpBodyData: httpBodyData, service: self, completion: requestHasFinishedLoad(data:error:))
        self.pumper?.start()

        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasStarted(self)
        }
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

@objc
public protocol WOTWebDataPumperProtocol {
    var completion: ((Data?, Error?) -> Void) { get }
    var description: String { get }

    init(request: URLRequest, completion: (@escaping (Data?, Error?) -> Void))
    func start()
}

class WOTWebDataPumper: NSObject, WOTWebDataPumperProtocol, NSURLConnectionDataDelegate {
    let request: URLRequest
    public private(set) var completion: ((Data?, Error?) -> Void)
    private var data: Data?
    private var connection: NSURLConnection?

    deinit {
        print("deinit WOTWebDataPumper")
    }

    override var hash: Int {
        return request.url?.absoluteString.hashValue ?? 0
    }

    override var description: String {
        return request.url?.absoluteString ?? "-"
    }

    convenience init(hostConfiguration: WOTHostConfigurationProtocol?, args: WOTRequestArgumentsProtocol, httpBodyData: Data?, service: WOTWebServiceProtocol, completion: (@escaping (Data?, Error?) -> Void)) {
        let requestBuilder = WOTWebRequestBuilder()
        let urlRequest = requestBuilder.build(service: service, hostConfiguration: hostConfiguration, args: args, bodyData: httpBodyData)
        self.init(request: urlRequest, completion: completion)
    }

    required init(request: URLRequest, completion: (@escaping (Data?, Error?) -> Void)) {
        self.request = request
        self.completion = completion

        super.init()

        connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
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
        self.completion(self.data, nil)
    }

    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.completion(nil, error)
        }
    }
}

extension WOTWEBRequest: WOTWebRequestProtocol {}

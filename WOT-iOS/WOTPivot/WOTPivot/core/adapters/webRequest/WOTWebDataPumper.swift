//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

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

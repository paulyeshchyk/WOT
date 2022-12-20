//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

class HttpDataReceiver: NSObject, HttpDataReceiverProtocol {
    enum WOTWebDataPumperError: Error {
        case urlNotDefined
    }

    let request: URLRequest?

    override var hash: Int {
        return request?.url?.absoluteString.hashValue ?? 0
    }

    override var description: String {
        return request?.url?.absoluteString ?? "-"
    }

    convenience init(context: HttpDataReceiverProtocol.Context, args: RequestArgumentsProtocol, httpBodyData: Data?, service: WOTWebServiceProtocol) {
        let requestBuilder = HttpRequestBuilder()
        let urlRequest: URLRequest?
        do {
            urlRequest = try requestBuilder.build(service: service, hostConfiguration: context.hostConfiguration, args: args, bodyData: httpBodyData)
        } catch {
            urlRequest = nil
        }
        self.init(context: context, request: urlRequest)
    }

    private let context: HttpDataReceiverProtocol.Context
    required init(context: HttpDataReceiverProtocol.Context, request: URLRequest?) {
        self.request = request
        self.context = context

        super.init()
    }

    public var onStart: ((HttpDataReceiverProtocol) -> ())?
    public var onComplete: ((HttpDataReceiverProtocol, Data?, Error?) -> ())?
    
    public func start() {
        guard let url = request?.url else {
            onComplete?(self, nil, WOTWebDataPumperError.urlNotDefined)
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            DispatchQueue.main.async { 
                self.onComplete?(self, data, error)
            }

        }.resume()
    }
}

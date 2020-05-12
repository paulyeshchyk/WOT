//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

class WOTWebDataPumper: NSObject, WOTWebDataPumperProtocol {
    enum WOTWebDataPumperError: Error {
        case urlNotDefined
    }

    let request: URLRequest
    public private(set) var completion: DataReceiveCompletion

    deinit {
//        print("deinit WOTWebDataPumper")
    }

    override var hash: Int {
        return request.url?.absoluteString.hashValue ?? 0
    }

    override var description: String {
        return request.url?.absoluteString ?? "-"
    }

    convenience init(hostConfiguration: WOTHostConfigurationProtocol, args: WOTRequestArgumentsProtocol, httpBodyData: Data?, service: WOTWebServiceProtocol, completion: @escaping DataReceiveCompletion) {
        let requestBuilder = WOTWebRequestBuilder()
        let urlRequest = requestBuilder.build(service: service, hostConfiguration: hostConfiguration, args: args, bodyData: httpBodyData)
        self.init(request: urlRequest, completion: completion)
    }

    required init(request: URLRequest, completion: @escaping DataReceiveCompletion) {
        self.request = request
        self.completion = completion

        super.init()
    }

    public func start() {
        guard let url = request.url else {
            completion(nil, WOTWebDataPumperError.urlNotDefined)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async { [weak self] in
                self?.completion(data, error)
            }

        }.resume()
    }
}

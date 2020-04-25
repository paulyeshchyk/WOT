//
//  WOTWebRequestBuilder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

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

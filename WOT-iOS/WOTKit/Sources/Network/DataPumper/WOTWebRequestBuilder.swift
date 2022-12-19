//
//  WOTWebRequestBuilder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

class WOTWebRequestBuilder {

    public func build(service: WOTWebServiceProtocol, hostConfiguration: HostConfigurationProtocol, args: RequestArgumentsProtocol, bodyData: Data?) -> URLRequest {
        let url = buildURL(hostConfiguration: hostConfiguration, path: service.path, args: args, bodyData: bodyData)

        var result = URLRequest(url: url)
        result.httpBody = bodyData
        result.timeoutInterval = 0
        result.httpMethod = service.method.stringRepresentation
        return result
    }

    private func buildURL(hostConfiguration: HostConfigurationProtocol, path: String, args: RequestArgumentsProtocol, bodyData: Data?) -> URL {
        let urlQuery: String? = hostConfiguration.urlQuery(with: args)

        var components = URLComponents()
        components.scheme = hostConfiguration.scheme
        components.host = hostConfiguration.host
        components.path = path
        if bodyData == nil {
            components.query = urlQuery
        }
        guard let result = components.url else {
            fatalError("url not created")
        }
        return result
    }
}

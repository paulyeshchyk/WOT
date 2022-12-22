//
//  WOTWebRequestBuilder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

class HttpRequestBuilder {

    private enum HttpRequestBuilderError: Error {
        case hostConfigurationIsNotDefined
        case urlNotCreated
    }
    
    public func build(service: HttpServiceProtocol, hostConfiguration: HostConfigurationProtocol?, args: RequestArgumentsProtocol, bodyData: Data?) throws -> URLRequest {
        let url = try buildURL(hostConfiguration: hostConfiguration, path: service.path, args: args, bodyData: bodyData)

        var result = URLRequest(url: url)
        result.httpBody = bodyData
        result.timeoutInterval = 0
        result.httpMethod = service.method.stringRepresentation
        return result
    }

    private func buildURL(hostConfiguration: HostConfigurationProtocol?, path: String, args: RequestArgumentsProtocol, bodyData: Data?) throws -> URL {
        
        guard  let hostConfiguration = hostConfiguration else {
            throw HttpRequestBuilderError.hostConfigurationIsNotDefined
        }

        var components = URLComponents()
        components.scheme = hostConfiguration.scheme
        components.host = hostConfiguration.host
        components.path = path
        if bodyData == nil {
            components.query = hostConfiguration.urlQuery(with: args)
        }
        guard let result = components.url else {
            throw HttpRequestBuilderError.urlNotCreated
        }
        return result
    }
}

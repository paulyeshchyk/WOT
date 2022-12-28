//
//  WOTWebRequestBuilder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

struct HttpRequestBuilder {
    private enum HttpRequestBuilderError: Error, CustomStringConvertible {
        case hostConfigurationIsNotDefined
        case urlNotCreated
        var description: String {
            switch self {
            case .hostConfigurationIsNotDefined: return "[\(type(of: self))]: HostConfiguration is not defined"
            case .urlNotCreated: return "[\(type(of: self))]: Url is not created"
            }
        }
    }

    public func build(hostConfiguration: HostConfigurationProtocol?, httpMethod: ContextSDK.HTTPMethod, path: String, args: RequestArgumentsProtocol?, bodyData: Data?) throws -> URLRequest {
        let url = try buildURL(hostConfiguration: hostConfiguration, path: path, args: args, bodyData: bodyData)

        var result = URLRequest(url: url)
        result.httpBody = bodyData
        result.timeoutInterval = 0
        result.httpMethod = httpMethod.stringRepresentation
        return result
    }

    private func buildURL(hostConfiguration: HostConfigurationProtocol?, path: String, args: RequestArgumentsProtocol?, bodyData: Data?) throws -> URL {
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

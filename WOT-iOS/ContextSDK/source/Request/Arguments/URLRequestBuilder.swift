//
//  URLRequestBuilder.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - URLRequestBuilder

struct URLRequestBuilder {

    public var httpRequest: (HttpRequestProtocol & HttpServiceProtocol)?
    public var hostConfiguration: HostConfigurationProtocol?

    // MARK: Public

    public func build() throws -> URLRequest {
        //
        let urlComponents = try buildURLComponents()
        guard let url = urlComponents.url else {
            throw Errors.urlNotCreated
        }

        var result = URLRequest(url: url)
        result.httpMethod = httpRequest?.httpMethod.stringRepresentation
        result.httpBody = httpRequest?.httpBodyData
        result.timeoutInterval = 0
        return result
    }

    // MARK: Private

    private func buildURLComponents() throws -> URLComponents {
        //
        guard let hostConfiguration = hostConfiguration else {
            throw Errors.hostConfigurationIsNotDefined
        }

        guard let httpRequest = httpRequest else {
            throw Errors.requestIsNotDefined
        }

        var components = URLComponents()
        components.scheme = hostConfiguration.scheme
        components.host = hostConfiguration.host
        components.path = httpRequest.path
        if httpRequest.httpBodyData == nil {
            components.query = hostConfiguration.urlQuery(with: httpRequest.arguments)
        }
        return components
    }
}

// MARK: - %t + URLRequestBuilder.Errors

extension URLRequestBuilder {

    enum Errors: Error, CustomStringConvertible {
        case hostConfigurationIsNotDefined
        case urlNotCreated
        case requestIsNotDefined

        var description: String {
            switch self {
            case .hostConfigurationIsNotDefined: return "[\(type(of: self))]: HostConfiguration is not defined"
            case .urlNotCreated: return "[\(type(of: self))]: Url is not created"
            case .requestIsNotDefined: return "[\(type(of: self))]: HttpRequest is not defined"
            }
        }
    }

}

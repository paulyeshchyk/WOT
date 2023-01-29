//
//  HttpRequestConfiguration.swift
//  ContextSDK
//
//  Created by Paul on 29.01.23.
//

// MARK: - HttpRequestConfiguration

@objc
public class HttpRequestConfiguration: NSObject, RequestConfigurationProtocol {

    public let modelClass: ModelClassType
    public var composer: FetchRequestPredicateComposerProtocol?
    public var modelFieldKeyPaths: [String]?

    public required init(modelClass: ModelClassType) {
        self.modelClass = modelClass
        super.init()
    }

    public func buildArguments(forRequest request: RequestProtocol?) throws -> RequestArgumentsProtocol {
        let composition = try composer?.buildRequestPredicateComposition()
        let contextPredicate = composition?.contextPredicate
        //
        let argumentsBuilder = HttpRequestArgumentsBuilder()
        argumentsBuilder.contextPredicate = contextPredicate
        argumentsBuilder.keyPaths = modelFieldKeyPaths
        argumentsBuilder.keypathPrefix = request?.httpAPIQueryPrefix()
        argumentsBuilder.httpQueryItemName = request?.httpQueryItemName

        return argumentsBuilder.build()
    }
}

// MARK: - %t + HttpRequestConfiguration.Errors

extension HttpRequestConfiguration {
    private enum Errors: Error {
        case modelClassIsNotDefined
    }
}

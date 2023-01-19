//
//  HttpJSONResponseConfiguration.swift
//  ContextSDK
//
//  Created by Paul on 18.01.23.
//

// MARK: - HttpJSONResponseConfiguration

@objc
public class HttpJSONResponseConfiguration: NSObject, ResponseConfigurationProtocol {

    public typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    public let modelClass: ModelClassType
    public var socket: JointSocketProtocol?
    public var extractor: ManagedObjectExtractable?

    public required init(modelClass: ModelClassType) {
        self.modelClass = modelClass
        super.init()
    }

    public func handleData(_ data: Data?, fromRequest request: RequestProtocol, forService modelService: RequestModelServiceProtocol, inAppContext appContext: Context, completion: WorkWithDataCompletion?) {
        //
        let linker = ManagedObjectLinker(modelClass: modelClass)
        linker.socket = socket

        let dataAdapter = type(of: modelService).dataAdapterClass().init(appContext: appContext, modelClass: modelClass)
        dataAdapter.request = request
        dataAdapter.linker = linker
        dataAdapter.extractor = extractor
        dataAdapter.completion = completion

        dataAdapter.decode(data: data, fromRequest: request)
    }

}

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

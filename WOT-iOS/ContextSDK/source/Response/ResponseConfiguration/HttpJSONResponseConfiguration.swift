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
        let responseDataDecoder = type(of: modelService).responseDataDecoderClass().init(appContext: appContext)
        responseDataDecoder.request = request
        responseDataDecoder.completion = { request, json, error in
            self.runSyndicate(appContext: appContext, request: request, json: json, error: error, completion: completion)
        }

        responseDataDecoder.decode(data: data, fromRequest: request)
    }

    private func runSyndicate(appContext: Context, request: RequestProtocol, json: JSON?, error: Error?, completion: WorkWithDataCompletion?) {
        guard error == nil else {
            completion?(request, error)
            return
        }

        guard let json = json else {
            completion?(request, nil)
            return
        }

        let dispatchGroup = DispatchGroup()

        let maps = extractor?.getJSONMaps(json: json, modelClass: modelClass, jsonRefs: request.contextPredicate?.jsonRefs)
        maps?.forEach { jsonMap in
            dispatchGroup.enter()

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, socket: socket, decodingDepthLevel: request.decodingDepthLevel) { _, error in
                if let error = error {
                    completion?(request, error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion?(request, nil)
        }
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

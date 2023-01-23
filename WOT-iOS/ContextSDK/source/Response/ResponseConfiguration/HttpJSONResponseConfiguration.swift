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

    let appContext: ResponseConfigurationProtocol.Context
    public var socket: JointSocketProtocol?
    public var extractor: ManagedObjectExtractable?

    public required init(appContext: ResponseConfigurationProtocol.Context) {
        self.appContext = appContext
        super.init()
    }

    public func handleData(_ data: Data?, fromRequest request: RequestProtocol, forService modelService: RequestModelServiceProtocol, inAppContext appContext: Context, completion: WorkWithDataCompletion?) {
        do {
            let uow_config = try UoW_Config__Parse_Fetch_Decode_Link(appContext: appContext,
                                                                     modelService: modelService,
                                                                     extractor: extractor,
                                                                     request: request,
                                                                     socket: socket,
                                                                     decodeDepthLevel: nil,
                                                                     data: data)
            let uow = try appContext.uowManager.uow(by: uow_config)
            uow.didStatusChanged = { uow in
                if uow.status == .finish {
                    completion?(request, nil)
                }
            }
            try appContext.uowManager.perform(uow: uow)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
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

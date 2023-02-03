//
//  RequestCreatorHelper.swift
//  ContextSDK
//
//  Created by Paul on 29.01.23.
//

// MARK: - RequestCreatorHeper

class RequestCreatorHeper {
    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol

    var modelClass: ModelClassType?
    var modelFieldKeyPaths: [String]?
    var contextPredicate: ContextPredicateProtocol?
    var decodingDepthLevel: DecodingDepthLevel?
    var completion: ((RequestProtocol?, Error?) -> Void)?

    private let appContext: Context
    init(appContext: Context) {
        self.appContext = appContext
    }

    func run() {
        do {
            guard let modelClass = modelClass else {
                throw RequestCreatorHeperErrors.modelIsNotDefined
            }
            guard let modelFieldKeyPaths = modelFieldKeyPaths else {
                throw RequestCreatorHeperErrors.modelFieldKeyPathsAreNotDefined
            }

            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelFieldKeyPaths
            httpRequestConfiguration.contextPredicate = contextPredicate

            guard let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration,
                                                                                 decodingDepthLevel: decodingDepthLevel)
            else {
                throw RequestCreatorHeperErrors.requestIsNotCreated
            }
            completion?(request, nil)
        } catch {
            completion?(nil, error)
        }
    }
}

// MARK: - %t + RequestCreatorHeper.RequestCreatorHeperErrors

extension RequestCreatorHeper {
    enum RequestCreatorHeperErrors: Error {
        case modelIsNotDefined
        case modelServiceNotDefined
        case extractorIsNotDefined
        case modelFieldKeyPathsAreNotDefined
        case requestIsNotCreated
    }
}

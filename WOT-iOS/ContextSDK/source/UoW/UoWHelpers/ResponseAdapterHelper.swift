//
//  ResponseAdapterHelper.swift
//  ContextSDK
//
//  Created by Paul on 29.01.23.
//

// MARK: - ResponseAdapterHelper

class ResponseAdapterHelper {
    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    var modelClass: ModelClassType?
    var socket: JointSocketProtocol?
    var extractorType: ManagedObjectExtractable.Type?
    var completion: ((Error?) -> Void)?

    private let appContext: Context
    init(appContext: Context) {
        self.appContext = appContext
    }

    func run(_ request: RequestProtocol?, inContextOfWork: UOWProtocol?, data: Data?) {
        guard let modelService = request as? RequestModelServiceProtocol else {
            completion?(ResponseAdapterHelperErrors.modelServiceNotDefined)
            return
        }

        let completionWrapper: ((UOWResultProtocol) -> Void) = { result in
            if let completion = self.completion {
                completion(result.error)
            } else {
                self.appContext.logInspector?.log(.warning("No completion defined for \(type(of: self))"), sender: self)
            }
        }

        let uowDecodeAndLink = UOWDecodeAndLinkMaps(appContext: appContext)
        uowDecodeAndLink.modelClass = modelClass
        uowDecodeAndLink.socket = socket
        uowDecodeAndLink.decodingDepthLevel = request?.decodingDepthLevel

        let jsonExtractorHelper = JSONExtractorHelper()
        jsonExtractorHelper.extractorType = extractorType
        jsonExtractorHelper.modelClass = modelClass
        jsonExtractorHelper.jsonRefs = request?.contextPredicate?.jsonRefs
        jsonExtractorHelper.completion = { maps, error in
            if let error = error { self.appContext.logInspector?.log(.warning(error: error), sender: self) }
            uowDecodeAndLink.maps = maps
            self.appContext.uowManager.run(unit: uowDecodeAndLink, inContextOfWork: inContextOfWork, listenerCompletion: completionWrapper)
        }

        let dataAdapter = type(of: modelService).dataAdapterClass().init(appContext: appContext)
        dataAdapter.completion = { json, error in
            if let error = error { self.appContext.logInspector?.log(.warning(error: error), sender: self) }
            jsonExtractorHelper.run(json: json)
        }

        dataAdapter.decode(data: data)
    }
}

// MARK: - %t + ResponseAdapterHelper.ResponseAdapterHelperErrors

extension ResponseAdapterHelper {
    enum ResponseAdapterHelperErrors: Error {
        case modelServiceNotDefined
        case extractorIsNotDefined
        case modelFieldKeyPathsAreNotDefined
    }
}

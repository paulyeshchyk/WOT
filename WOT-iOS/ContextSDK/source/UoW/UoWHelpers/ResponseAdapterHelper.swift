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

    private let appContext: Context
    var modelClass: ModelClassType?
    var socket: JointSocketProtocol?
    var extractor: ManagedObjectExtractable?
    var completion: ((UOWResultProtocol) -> Void)?
    init(appContext: Context) {
        self.appContext = appContext
    }

    func run(_ request: RequestProtocol?, data: Data?) {
        guard let modelService = request as? RequestModelServiceProtocol else {
            completion?(UOWResult(fetchResult: nil, error: ResponseAdapterHelperErrors.modelServiceNotDefined))
            return
        }

        let dataAdapter = type(of: modelService).dataAdapterClass().init(appContext: appContext)
        dataAdapter.modelClass = modelClass
        dataAdapter.request = request
        dataAdapter.socket = socket
        dataAdapter.extractor = extractor
        dataAdapter.completion = { _, error in
            self.completion?(UOWResult(fetchResult: nil, error: error))
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

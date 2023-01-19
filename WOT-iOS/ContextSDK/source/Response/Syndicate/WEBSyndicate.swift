//
//  WEBSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 19.01.23.
//

// MARK: - WEBSyndicate

class WEBSyndicate {

    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol

    public typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    private let appContext: Context
    var modelService: RequestModelServiceProtocol?
    var socket: JointSocketProtocol?
    var decodeDepthLevel: DecodingDepthLevel?
    var extractor: ManagedObjectExtractable?
    let request: RequestProtocol
    var completion: ((RequestProtocol, Error?) -> Void)?

    init(appContext: Context, request: RequestProtocol) {
        self.appContext = appContext
        self.request = request
    }

    // MARK: Internal

    func run(data: Data?) {
        guard let modelService = modelService else {
            completion?(request, Errors.modelServiceIsNotDefined)
            return
        }
        let responseDecoderClass = type(of: modelService).responseDataDecoderClass()
        let modelClass = type(of: modelService).modelClass()

        //
        let jsonMapCreator = JSONMapHelper(appContext: appContext)
        jsonMapCreator.modelClass = modelClass
        jsonMapCreator.extractor = extractor
        jsonMapCreator.contextPredicate = request.contextPredicate
        jsonMapCreator.completion = { result in
            if let error = result.error {
                self.completion?(self.request, error)
            } else {
                JSONSyndicate.decodeAndLink(appContext: self.appContext,
                                            jsonMap: result.map,
                                            modelClass: modelClass,
                                            socket: self.socket,
                                            decodingDepthLevel:
                                            self.request.decodingDepthLevel) { _, error in
                    if result.completed {
                        self.completion?(self.request, error)
                    }
                }
            }
        }

        let responseDataDecoder = responseDecoderClass.init(appContext: appContext)
        responseDataDecoder.request = request
        responseDataDecoder.completion = { _, json, error in
            jsonMapCreator.run(json: json, error: error)
        }

        responseDataDecoder.decode(data: data, fromRequest: request)
    }
}

// MARK: - %t + WEBSyndicate.Errors

extension WEBSyndicate {
    enum Errors: Error {
        case modelServiceIsNotDefined
        case requestIsNotDefined
    }
}

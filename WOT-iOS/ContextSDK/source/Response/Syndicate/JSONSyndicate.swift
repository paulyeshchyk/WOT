//
//  WEBSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 19.01.23.
//

// MARK: - JSONSyndicate

class JSONSyndicate {

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
        guard decodeDepthLevel?.maxReached() ?? true else {
            completion?(request, Errors.reachedMaxDecodingDepthLevel)
            return
        }

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
                MOSyndicate.fetch_decode_link(appContext: self.appContext,
                                              jsonMap: result.map,
                                              modelClass: modelClass,
                                              socket: self.socket,
                                              decodingDepthLevel: self.request.decodingDepthLevel) { _, error in
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

// MARK: - %t + JSONSyndicate.Errors

extension JSONSyndicate {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case modelServiceIsNotDefined
        case requestIsNotDefined
        case jsonExtractorIsNotPresented
        case reachedMaxDecodingDepthLevel

        public var description: String {
            switch self {
            case .modelServiceIsNotDefined: return "\(type(of: self)): model service is not presented"
            case .requestIsNotDefined: return "\(type(of: self)): request is not presented"
            case .jsonExtractorIsNotPresented: return "\(type(of: self)): json extrator is not presented"
            case .reachedMaxDecodingDepthLevel: return "\(type(of: self)): Reached max decoding depth level"
            }
        }
    }
}

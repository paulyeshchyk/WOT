//
//  WEBSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 19.01.23.
//

// MARK: - JSONSyndicate

class JSONSyndicate {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UoW_ManagerContainerProtocol

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
        let jsonMapHelper = JSONMapHelper(appContext: appContext)
        jsonMapHelper.modelClass = modelClass
        jsonMapHelper.extractor = extractor
        jsonMapHelper.contextPredicate = request.contextPredicate
        jsonMapHelper.completion = { jsonMaps, error in
            if let err = error {
                self.completion?(self.request, err)
            } else {
                let config = UoW_Config__Fetch_Decode_Link()
                config.appContext = self.appContext
                config.jsonMaps = jsonMaps
                config.modelClass = modelClass
                config.socket = self.socket
                config.decodingDepthLevel = self.decodeDepthLevel
                do {
                    let uow = try self.appContext.uowManager.uow(by: config)
                    uow.didStatusChanged = { uow in
                        if uow.status == .finish {
                            self.completion?(self.request, nil)
                        }
                    }
                    try self.appContext.uowManager.perform(uow: uow)
                } catch {
                    //
                }
            }
        }

        let responseDataDecoder = responseDecoderClass.init(appContext: appContext)
        responseDataDecoder.request = request
        responseDataDecoder.completion = { _, json, error in
            jsonMapHelper.run(json: json, error: error)
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

//
//  UoW__Parse_Fetch_Decode_Link.swift
//  ContextSDK
//
//  Created by Paul on 21.01.23.
//

// MARK: - UoW__Parse_Fetch_Decode_Link

class UoW__Parse_Fetch_Decode_Link: UoW_Protocol {

    public var MD5: String { uuid.MD5 }
    private let uuid = UUID()

    public var status: UoW_Status = .unknown { didSet { didStatusChanged?(self) } }
    public var didStatusChanged: ((_ uow: UoW_Protocol) -> Void)?
    public var configuration: UoW_Config_Protocol
    private var config: UoW_Config__Parse_Fetch_Decode_Link

    public required init(configuration: UoW_Config_Protocol) throws {
        self.configuration = configuration
        guard let cfg = configuration as? UoW_Config__Parse_Fetch_Decode_Link else {
            throw Errors.invalidConfig
        }
        config = cfg
    }

    func run(forListener listener: UoW_Listener) throws {
        let responseDecoderClass = type(of: config.modelService).responseDataDecoderClass()
        let modelClass = type(of: config.modelService).modelClass()

        //
        let jsonMapHelper = JSONMapHelper(appContext: config.appContext)
        jsonMapHelper.modelClass = modelClass
        jsonMapHelper.extractor = config.extractor
        jsonMapHelper.contextPredicate = config.request.contextPredicate
        jsonMapHelper.completion = { jsonMaps, error in
            if error != nil {
                listener.didFinishUOW(self, error: error)
                return
            }
            guard let jsonMaps = jsonMaps else {
                listener.didFinishUOW(self, error: nil)
                return
            }

            for (index, jsonMap) in jsonMaps.enumerated() {
                let moLinkHelper = MOLinkHelper(appContext: self.config.appContext)
                moLinkHelper.socket = self.config.socket
                moLinkHelper.completion = { _, _ in
                    let completed = (index == jsonMaps.count - 1)
                    if completed {
                        listener.didFinishUOW(self, error: nil)
                    }
                }

                let moDecodeHelper = MODecodeHelper(appContext: self.config.appContext)
                moDecodeHelper.jsonMap = jsonMap
                moDecodeHelper.completion = { fetchResult, error in
                    moLinkHelper.run(fetchResult, error: error)
                }

                let moFetchHelper = MOFetchHelper(appContext: self.config.appContext)
                moFetchHelper.modelClass = modelClass
                moFetchHelper.nspredicate = jsonMap.contextPredicate.nspredicate(operator: .and)
                moFetchHelper.completion = { fetchResult, error in
                    moDecodeHelper.run(fetchResult, error: error)
                }

                moFetchHelper.run(nil, error: nil)
            }
        }

        let responseDataDecoder = responseDecoderClass.init(appContext: config.appContext)
        responseDataDecoder.request = config.request
        responseDataDecoder.completion = { _, json, error in
            jsonMapHelper.run(json: json, error: error)
        }

        responseDataDecoder.decode(data: config.data, fromRequest: config.request)
    }
}

// MARK: - %t + UoW__Parse_Fetch_Decode_Link.Errors

extension UoW__Parse_Fetch_Decode_Link {
    enum Errors: Error {
        case invalidConfig
    }
}

// MARK: - UoW_Config__Parse_Fetch_Decode_Link

public class UoW_Config__Parse_Fetch_Decode_Link: UoW_Config_Protocol {

    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UoW_ManagerContainerProtocol

    public var uowType: UoW_Protocol.Type { UoW__Parse_Fetch_Decode_Link.self }

    var appContext: Context
    var modelService: RequestModelServiceProtocol
    var extractor: ManagedObjectExtractable
    var request: RequestProtocol
    var socket: JointSocketProtocol?
    var decodeDepthLevel: DecodingDepthLevel?
    var data: Data

    public init(appContext: Context,
                modelService: RequestModelServiceProtocol,
                extractor: ManagedObjectExtractable?,
                request: RequestProtocol,
                socket: JointSocketProtocol?,
                decodeDepthLevel: DecodingDepthLevel?,
                data: Data?) throws {
        //
        self.appContext = appContext
        self.modelService = modelService

        guard let extractor = extractor else { throw Errors.extractorIsNil }
        self.extractor = extractor

        self.request = request
        self.socket = socket
        self.decodeDepthLevel = decodeDepthLevel

        guard let data = data else { throw Errors.dataIsNil }
        self.data = data
    }
}

// MARK: - %t + UoW_Config__Parse_Fetch_Decode_Link.Errors

extension UoW_Config__Parse_Fetch_Decode_Link {
    enum Errors: Error {
        case jsonMapIsEmpty
        case appContextIsEmpty
        case modelClassIsEmpty
        case dataIsNil
        case extractorIsNil
    }
}

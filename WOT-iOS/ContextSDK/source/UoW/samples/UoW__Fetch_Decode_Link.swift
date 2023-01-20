//
//  UoW__Fetch_Decode_Link.swift
//  ContextSDK
//
//  Created by Paul on 20.01.23.
//

// MARK: - UoW__Fetch_Decode_Link

public class UoW__Fetch_Decode_Link: UoW_Protocol {

    public var MD5: String { uuid.MD5 }
    private let uuid = UUID()

    public var status: UoW_Status {
        didSet {
            didStatusChanged?(self)
        }
    }

    public var didStatusChanged: ((_ uow: UoW_Protocol) -> Void)?
    public var data: UoW_Config_Protocol { config }

    private var config: UoW_Config__Fetch_Decode_Link

    public required init(config: UoW_Config_Protocol) throws {
        guard let cfg = config as? UoW_Config__Fetch_Decode_Link else {
            throw Errors.invalidConfig
        }
        self.config = cfg
        status = .initialization
    }

    // RUN

    public func run(forListener listener: UoW_Listener) throws {
        status = .inProgress

        let config = try config.unwrapped()

        for (index, jsonMap) in config.jsonMaps.enumerated() {
            let moLinkHelper = MOLinkHelper(appContext: config.appContext)
            moLinkHelper.socket = config.socket
            moLinkHelper.completion = { _, _ in
                let completed = (index == config.jsonMaps.count - 1)
                if completed {
                    self.status = .finish
                    listener.didFinishUOW(self, error: nil)
                }
            }

            let moDecodeHelper = MODecodeHelper(appContext: config.appContext)
            moDecodeHelper.jsonMap = jsonMap
            moDecodeHelper.completion = { fetchResult, error in
                moLinkHelper.run(fetchResult, error: error)
            }

            let moFetchHelper = MOFetchHelper(appContext: config.appContext)
            moFetchHelper.modelClass = config.modelClass
            moFetchHelper.nspredicate = jsonMap.contextPredicate.nspredicate(operator: .and)
            moFetchHelper.completion = { fetchResult, error in
                moDecodeHelper.run(fetchResult, error: error)
            }

            moFetchHelper.run(nil, error: nil)
        }
    }
}

// MARK: - %t + UoW__Fetch_Decode_Link.Errors

extension UoW__Fetch_Decode_Link {
    enum Errors: Error {
        case invalidConfig
    }
}

// MARK: - UoW_Config__Fetch_Decode_Link

public class UoW_Config__Fetch_Decode_Link: UoW_Config_Protocol {

    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UoW_ManagerContainerProtocol

    public typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    public var uowType: UoW_Protocol.Type {
        UoW__Fetch_Decode_Link.self
    }

    public var jsonMaps: [JSONMapProtocol]?
    public var modelClass: ModelClassType?
    public var appContext: Context?
    public var socket: JointSocketProtocol?
    public var decodingDepthLevel: DecodingDepthLevel?

    public struct Unwrapped {
        var appContext: Context
        var modelClass: ModelClassType
        var socket: JointSocketProtocol?
        var jsonMaps: [JSONMapProtocol]
    }

    public func unwrapped() throws -> Unwrapped {
        guard let jsonMaps = jsonMaps else { throw Errors.jsonMapIsEmpty }
        guard let appContext = appContext else { throw Errors.appContextIsEmpty }
        guard let modelClass = modelClass else { throw Errors.modelClassIsEmpty }
        return Unwrapped(appContext: appContext, modelClass: modelClass, socket: socket, jsonMaps: jsonMaps)
    }

    public init() {}
}

// MARK: - %t + UoW_Config__Fetch_Decode_Link.Errors

extension UoW_Config__Fetch_Decode_Link {
    enum Errors: Error {
        case jsonMapIsEmpty
        case appContextIsEmpty
        case modelClassIsEmpty
    }
}

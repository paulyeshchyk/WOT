//
//  UOWDecodeAndLinkMap.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

// MARK: - UOWDecodeAndLinkMapProtocol

public protocol UOWDecodeAndLinkMapProtocol: UOWProtocol {
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var appContext: Context? { get set }
    var map: JSONMapProtocol? { get set }
    var modelClass: ModelClassType? { get set }
    var socket: JointSocketProtocol? { get set }
    var decodingDepthLevel: DecodingDepthLevel? { get set }
}

// MARK: - UOWDecodeAndLinkMap

public class UOWDecodeAndLinkMap: UOWDecodeAndLinkMapProtocol {

    public let uowType: UOWType = .decodeAndLink
    //
    private let uuid = UUID()
    public var MD5: String { uuid.MD5 }
    //
    public var appContext: Context?
    public var map: JSONMapProtocol?
    public var modelClass: ModelClassType?
    public var socket: JointSocketProtocol?
    public var decodingDepthLevel: DecodingDepthLevel?

    public init() {
        //
    }

    deinit {
        //
    }
}

// MARK: - UOWDecodeAndLinkMap + UOWRunnable

extension UOWDecodeAndLinkMap: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in
            guard let appContext = self.appContext else {
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: nil))
                return
            }
            guard let modelClass = self.modelClass else {
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: nil))
                return
            }

            guard let element = self.map else {
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: Errors.noMapProvided))
                return
            }

            let jsonSyndicate = JSONSyndicate(appContext: appContext, modelClass: modelClass)
            jsonSyndicate.decodeDepthLevel = self.decodingDepthLevel
            jsonSyndicate.jsonMap = element
            jsonSyndicate.socket = self.socket

            jsonSyndicate.completion = { fetchResult, error in
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: fetchResult, error: error))
            }
            jsonSyndicate.run()
        }
    }
}

// MARK: - %t + UOWDecodeAndLinkMap.Errors

extension UOWDecodeAndLinkMap {
    enum Errors: Error {
        case noMapProvided
    }
}

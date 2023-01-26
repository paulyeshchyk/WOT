//
//  UOWDecodeAndLinkMaps.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

// MARK: - UOWDecodeAndLinkMapsProtocol

public protocol UOWDecodeAndLinkMapsProtocol: UOWProtocol {

    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var appContext: Context? { get set }
    var maps: [JSONMapProtocol?]? { get set }
    var modelClass: ModelClassType? { get set }
    var socket: JointSocketProtocol? { get set }
    var decodingDepthLevel: DecodingDepthLevel? { get set }
}

// MARK: - UOWDecodeAndLinkMaps

public class UOWDecodeAndLinkMaps: UOWDecodeAndLinkMapsProtocol {

    public let uowType: UOWType = .decodeAndLink
    //
    private let uuid = UUID()
    public var MD5: String { uuid.MD5 }
    //
    public var appContext: Context?
    public var maps: [JSONMapProtocol?]?
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

// MARK: - UOWDecodeAndLinkMapsResult

struct UOWDecodeAndLinkMapsResult: UOWResultProtocol {
    public let fetchResult: Any?
    public let error: Error?

    // MARK: Lifecycle

    public init(fetchResult: Any?, error: Error?) {
        self.fetchResult = fetchResult
        self.error = error
    }
}

// MARK: - UOWDecodeAndLinkMaps + UOWRunnable

extension UOWDecodeAndLinkMaps: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in
            do {
                self.appContext?.logInspector?.log(.flow(name: "mapAndLink", message: "start"), sender: self)
                guard let appContext = self.appContext else {
                    throw Errors.noAppContextProvided
                }
                guard let modelClass = self.modelClass else {
                    throw Errors.noModelClassProvided
                }

                guard let elements = self.maps?.compactMap({ $0 }) else {
                    throw Errors.noMapProvided
                }

                let sequence = elements.map { element -> UOWDecodeAndLinkMap in
                    let uow = UOWDecodeAndLinkMap()
                    uow.appContext = appContext
                    uow.modelClass = modelClass
                    uow.map = element
                    uow.socket = self.socket
                    uow.decodingDepthLevel = self.decodingDepthLevel
                    return uow
                }

                try appContext.uowManager.run(sequence: sequence) { _, error in
                    self.appContext?.logInspector?.log(.flow(name: "mapAndLink", message: "finish"), sender: self)
                    exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: error))
                }
            } catch {
                self.appContext?.logInspector?.log(.flow(name: "mapAndLink", message: "finish"), sender: self)
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: error))
            }
        }
    }
}

// MARK: - UOWDecodeAndLinkMaps.Errors

extension UOWDecodeAndLinkMaps {
    enum Errors: Error {
        case noMapProvided
        case noAppContextProvided
        case noModelClassProvided
    }
}

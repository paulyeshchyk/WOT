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
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol

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
    private let appContext: Context
    public var maps: [JSONMapProtocol?]?
    public var modelClass: ModelClassType?
    public var socket: JointSocketProtocol?
    public var decodingDepthLevel: DecodingDepthLevel?

    public init(appContext: Context) {
        self.appContext = appContext
    }

    deinit {}
}

// MARK: - UOWDecodeAndLinkMaps + CustomStringConvertible, CustomDebugStringConvertible

extension UOWDecodeAndLinkMaps: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        "[\(type(of: self))] \(debugDescription)"
    }

    public var debugDescription: String {
        let modelDescription: String?
        if let modelClass = modelClass {
            modelDescription = "model: \(type(of: modelClass))"
        } else {
            modelDescription = nil
        }
        let socketDescription: String?
        if let socket = socket {
            socketDescription = "socket: \(String(describing: socket))"
        } else {
            socketDescription = nil
        }
        return [modelDescription, socketDescription].compactMap { $0 }.joined(separator: ", ")
    }
}

// MARK: - UOWDecodeAndLinkMaps + UOWRunnable

extension UOWDecodeAndLinkMaps: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in
            do {
                guard let modelClass = self.modelClass else {
                    throw UOWDecodeAndLinkMapsError.noModelClassProvided
                }
                self.appContext.logInspector?.log(.uow("moParseSet", message: "start \(self.debugDescription)"), sender: self)

                guard let elements = self.maps?.compactMap({ $0 }), !elements.isEmpty else {
                    throw UOWDecodeAndLinkMapsError.noMapProvided(modelClass)
                }

                let sequence = elements.map { element -> UOWDecodeAndLinkMap in
                    let uow = UOWDecodeAndLinkMap(appContext: self.appContext)
                    uow.modelClass = modelClass
                    uow.map = element
                    uow.socket = self.socket
                    uow.decodingDepthLevel = self.decodingDepthLevel
                    return uow
                }

                self.appContext.uowManager.run(units: sequence, inContextOfWork: self) { error in
                    self.appContext.logInspector?.log(.uow("moParseSet", message: "finish \(self.debugDescription)"), sender: self)
                    exit(exitToPassThrough, UOWResult(uow: self, fetchResult: nil, error: error))
                }
            } catch {
                self.appContext.logInspector?.log(.uow("moParseSet", message: "finish \(self.debugDescription)"), sender: self)
                exit(exitToPassThrough, UOWResult(uow: self, fetchResult: nil, error: error))
            }
        }
    }
}

// MARK: - %t + UOWDecodeAndLinkMaps.UOWDecodeAndLinkMapsError

extension UOWDecodeAndLinkMaps {
    enum UOWDecodeAndLinkMapsError: Error, CustomStringConvertible {
        case noMapProvided(ModelClassType)
        case noModelClassProvided

        var description: String {
            switch self {
            case .noMapProvided(let modelClass): return "[\(type(of: self))]: no maps provided for \(type(of: modelClass))"
            case .noModelClassProvided: return "[\(type(of: self))]: no model provided"
            }
        }
    }
}

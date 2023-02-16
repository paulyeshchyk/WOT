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
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol

    var map: JSONMapProtocol? { get set }
    var modelClass: ModelClassType? { get set }
    var socket: JointSocketProtocol? { get set }
    var decodingDepthLevel: DecodingDepthLevel? { get set }
}

// MARK: - UOWDecodeAndLinkMap

public class UOWDecodeAndLinkMap: UOWDecodeAndLinkMapProtocol, CustomStringConvertible, CustomDebugStringConvertible {

    public let uowType: UOWType = .decodeAndLink
    //
    private let uuid = UUID()
    public var MD5: String { uuid.MD5 }
    //
    public var description: String {
        "[\(type(of: self))] \(debugDescription)"
    }

    public var debugDescription: String {
        let socketDescr: String?
        if let socket = socket {
            socketDescr = "socket: \(String(describing: socket))"
        } else {
            socketDescr = nil
        }
        let modelClassDescr: String?
        if let modelClass = modelClass {
            modelClassDescr = "modelClass: \(type(of: modelClass))"
        } else {
            modelClassDescr = nil
        }

        return [modelClassDescr, socketDescr].compactMap { $0 }.joined(separator: ", ")
    }

    private let appContext: Context
    public var map: JSONMapProtocol?
    public var modelClass: ModelClassType?
    public var socket: JointSocketProtocol?
    public var decodingDepthLevel: DecodingDepthLevel?

    public init(appContext: Context) {
        self.appContext = appContext
    }

    deinit {}
}

// MARK: - UOWDecodeAndLinkMap + UOWRunnable

extension UOWDecodeAndLinkMap: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in
            self.appContext.logInspector?.log(.uow("moParse", message: "start \(self.debugDescription)"), sender: self)
            do {
                guard let modelClass = self.modelClass else {
                    throw Errors.noModelClassProvided
                }

                guard let element = self.map else {
                    throw Errors.noMapProvided
                }

                let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: self.appContext)
                managedObjectLinkerHelper.socket = self.socket
                managedObjectLinkerHelper.completion = { fetchResult, error in
                    if let error = error { self.appContext.logInspector?.log(.error(error), sender: self) }
                    self.appContext.logInspector?.log(.uow("moParse", message: "finish \(self.debugDescription)"), sender: self)
                    exit(exitToPassThrough, UOWResult(uow: self, fetchResult: fetchResult, error: error))
                }

                let mappingCoordinatorDecodeHelper = ManagedObjectDecodeHelper(appContext: self.appContext, decodingDepthLevel: self.decodingDepthLevel)
                mappingCoordinatorDecodeHelper.inContextOfWork = self
                mappingCoordinatorDecodeHelper.jsonMap = element
                mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
                    if let error = error { self.appContext.logInspector?.log(.error(error), sender: self) }
                    managedObjectLinkerHelper.run(fetchResult)
                }

                let datastoreFetchHelper = DatastoreFetchHelper(appContext: self.appContext)
                datastoreFetchHelper.modelClass = modelClass
                datastoreFetchHelper.nspredicate = element.contextPredicate.nspredicate(operator: .and)
                datastoreFetchHelper.completion = { fetchResult, error in
                    if let error = error { self.appContext.logInspector?.log(.error(error), sender: self) }
                    mappingCoordinatorDecodeHelper.run(fetchResult)
                }

                datastoreFetchHelper.run()
            } catch {
                self.appContext.logInspector?.log(.uow("moParse", message: "finish \(self.debugDescription)"), sender: self)
                exit(exitToPassThrough, UOWResult(uow: self, fetchResult: nil, error: error))
            }
        }
    }
}

// MARK: - %t + UOWDecodeAndLinkMap.Errors

extension UOWDecodeAndLinkMap {
    enum Errors: Error {
        case noMapProvided
        case noModelClassProvided
    }
}

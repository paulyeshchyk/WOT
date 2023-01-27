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
            self.appContext?.logInspector?.log(.uow(name: "decodeLink", message: "start \(self.debugDescription)"), sender: self)
            do {
                guard let modelClass = self.modelClass else {
                    throw Errors.noAppContextProvided
                }

                guard let appContext = self.appContext else {
                    throw Errors.noAppContextProvided
                }
                guard let element = self.map else {
                    throw Errors.noMapProvided
                }

                let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
                managedObjectLinkerHelper.socket = self.socket
                managedObjectLinkerHelper.completion = { fetchResult, error in
                    if let error = error { appContext.logInspector?.log(.error(error), sender: self) }
                    self.appContext?.logInspector?.log(.uow(name: "decodeLink", message: "finish \(self.debugDescription)"), sender: self)
                    exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: fetchResult, error: error))
                }

                let mappingCoordinatorDecodeHelper = ManagedObjectDecodeHelper(appContext: appContext, decodingDepthLevel: self.decodingDepthLevel)
                mappingCoordinatorDecodeHelper.jsonMap = element
                mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
                    if let error = error { appContext.logInspector?.log(.error(error), sender: self) }
                    managedObjectLinkerHelper.run(fetchResult)
                }

                let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
                datastoreFetchHelper.modelClass = modelClass
                datastoreFetchHelper.nspredicate = element.contextPredicate.nspredicate(operator: .and)
                datastoreFetchHelper.completion = { fetchResult, error in
                    if let error = error { appContext.logInspector?.log(.error(error), sender: self) }
                    mappingCoordinatorDecodeHelper.run(fetchResult)
                }

                datastoreFetchHelper.run()
            } catch {
                self.appContext?.logInspector?.log(.uow(name: "decodeLink", message: "finish \(self.debugDescription)"), sender: self)
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: nil, error: error))
            }
        }
    }
}

// MARK: - %t + UOWDecodeAndLinkMap.Errors

extension UOWDecodeAndLinkMap {
    enum Errors: Error {
        case noMapProvided
        case noAppContextProvided
        case noModelClassProvided
    }
}

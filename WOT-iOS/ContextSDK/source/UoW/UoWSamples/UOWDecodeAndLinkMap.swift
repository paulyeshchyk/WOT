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

            let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
            managedObjectLinkerHelper.socket = self.socket
            managedObjectLinkerHelper.completion = { fetchResult, error in
                exit(exitToPassThrough, UOWDecodeAndLinkMapsResult.init(fetchResult: fetchResult, error: error))
            }

            let mappingCoordinatorDecodeHelper = ManagedObjectDecodeHelper(appContext: appContext)
            mappingCoordinatorDecodeHelper.jsonMap = element
            mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
                managedObjectLinkerHelper.run(fetchResult, error: error)
            }

            let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
            datastoreFetchHelper.modelClass = modelClass
            datastoreFetchHelper.nspredicate = element.contextPredicate.nspredicate(operator: .and)
            datastoreFetchHelper.completion = { fetchResult, error in
                mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
            }

            datastoreFetchHelper.run()
        }
    }
}

// MARK: - %t + UOWDecodeAndLinkMap.Errors

extension UOWDecodeAndLinkMap {
    enum Errors: Error {
        case noMapProvided
    }
}

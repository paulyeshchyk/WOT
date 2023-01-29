//
//  UOWRemote.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWRemoteProtocol

public protocol UOWRemoteProtocol: UOWProtocol {
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol

    var modelClass: ModelClassType? { get set }
    var modelFieldKeyPaths: [String]? { get set }
    var socket: JointSocketProtocol? { get set }
    var extractor: ManagedObjectExtractable? { get set }
    var composer: FetchRequestPredicateComposerProtocol? { get set }
    var nextDepthLevel: DecodingDepthLevel? { get set }

}

// MARK: - UOWRemote

public class UOWRemote: UOWRemoteProtocol, CustomStringConvertible, CustomDebugStringConvertible {
    public var uowType: UOWType = .remote

    private let uuid = UUID()
    public var MD5: String { uuid.MD5 }
    public var description: String {
        "[\(type(of: self))]"
    }

    public var debugDescription: String {
        ""
    }

    public var modelClass: ModelClassType?
    public var socket: JointSocketProtocol?
    public var extractor: ManagedObjectExtractable?
    public var composer: FetchRequestPredicateComposerProtocol?
    public var nextDepthLevel: DecodingDepthLevel?
    public var modelFieldKeyPaths: [String]?

    private var extToPathThrough: ListenerCompletionType = { _ in }
    private var ext: (@escaping ListenerCompletionType, UOWResultProtocol) -> Void = { _, _ in }

    private let appContext: Context
    public init(appContext: Context) {
        self.appContext = appContext
    }

    deinit {}
}

// MARK: - UOWRemote + RequestManagerListenerProtocol

extension UOWRemote: RequestManagerListenerProtocol {
    public func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, error: Error?) {
        requestManager.removeListener(self)
        ext(extToPathThrough, UOWResult.init(fetchResult: nil, error: error))
    }

    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    public func requestManager(_ requestManager: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        requestManager.removeListener(self)
        ext(extToPathThrough, UOWResult.init(fetchResult: nil, error: nil))
    }
}

// MARK: - UOWRemote + UOWRunnable

extension UOWRemote: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in

            self.extToPathThrough = exitToPassThrough
            self.ext = exit

            self.appContext.logInspector?.log(.uow("moParse", message: "start \(self.debugDescription)"), sender: self)
            do {
                guard let modelClass = self.modelClass else {
                    throw UOWRemoteErrors.modelIsNotDefined
                }
                guard let modelFieldKeyPaths = self.modelFieldKeyPaths else {
                    throw UOWRemoteErrors.modelFieldKeyPathsAreNotDefined
                }
                let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
                httpJSONResponseConfiguration.socket = self.socket
                httpJSONResponseConfiguration.extractor = self.extractor

                let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
                httpRequestConfiguration.modelFieldKeyPaths = modelFieldKeyPaths
                httpRequestConfiguration.composer = self.composer

                guard let request = try self.appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration,
                                                                                          responseConfiguration: httpJSONResponseConfiguration,
                                                                                          decodingDepthLevel: self.nextDepthLevel)
                else {
                    throw UOWRemoteErrors.requestIsNotCreated
                }
                try self.appContext.requestManager?.startRequest(request, listener: self)

            } catch {
                self.appContext.logInspector?.log(.uow("moParse", message: "finish \(self.debugDescription)"), sender: self)
                exit(exitToPassThrough, UOWResult.init(fetchResult: nil, error: error))
            }
        }
    }
}

// MARK: - %t + UOWRemote.UOWRemoteErrors

extension UOWRemote {
    enum UOWRemoteErrors: Error {
        case modelIsNotDefined
        case extractorIsNotDefined
        case modelFieldKeyPathsAreNotDefined
        case requestIsNotCreated
    }
}

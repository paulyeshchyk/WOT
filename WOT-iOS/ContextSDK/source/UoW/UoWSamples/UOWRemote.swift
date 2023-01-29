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

// MARK: - UOWRemote + UOWRunnable

extension UOWRemote: UOWRunnable {

    func runnableBlock() -> UOWRunnable.RunnableBlockType? {
        return { exitToPassThrough, exit in

            self.extToPathThrough = exitToPassThrough
            self.ext = exit

            self.appContext.logInspector?.log(.uow("remote", message: "start \(self.debugDescription)"), sender: self)

            let responseAdapterHelper = ResponseAdapterHelper(appContext: self.appContext)
            responseAdapterHelper.modelClass = self.modelClass
            responseAdapterHelper.socket = self.socket
            responseAdapterHelper.extractor = self.extractor
            responseAdapterHelper.completion = { fetchResult in
                self.appContext.logInspector?.log(.uow("remote", message: "finish \(self.debugDescription)"), sender: self)
                exit(exitToPassThrough, fetchResult)
            }

            let requestRunnerHelper = RequestRunnerHelper(appContext: self.appContext)
            requestRunnerHelper.completion = { request, data, error in
                if let error = error { self.appContext.logInspector?.log(.error(error), sender: self) }
                responseAdapterHelper.run(request, data: data)
            }

            let requestCreatorHelper = RequestCreatorHeper(appContext: self.appContext)
            requestCreatorHelper.modelClass = self.modelClass
            requestCreatorHelper.modelFieldKeyPaths = self.modelFieldKeyPaths
            requestCreatorHelper.composer = self.composer
            requestCreatorHelper.nextDepthLevel = self.nextDepthLevel
            requestCreatorHelper.completion = { request, error in
                if let error = error { self.appContext.logInspector?.log(.error(error), sender: self) }
                requestRunnerHelper.run(request)
            }

            requestCreatorHelper.run()
        }
    }
}

// MARK: - %t + UOWRemote.UOWRemoteErrors

extension UOWRemote {
    enum UOWRemoteErrors: Error {
        case modelIsNotDefined
        case modelServiceNotDefined
        case extractorIsNotDefined
        case modelFieldKeyPathsAreNotDefined
        case requestIsNotCreated
    }
}

//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestManager

@objc
open class RequestManager: NSObject {

    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & HostConfigurationContainerProtocol
        & DecoderManagerContainerProtocol
        & ResponseManagerContainerProtocol

    override public var description: String { String(describing: type(of: self)) }

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()
    private let appContext: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList
    private let linkerList: ResponseManagedObjectLinkerList
    private let extractorList: ResponseManagedObjectExtractorList

    private let requestRegistrator: RequestRegistratorProtocol

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
        grouppedRequestList = RequestGrouppedRequestList(appContext: appContext)
        grouppedListenerList = RequestGrouppedListenerList()
        linkerList = ResponseManagedObjectLinkerList()
        extractorList = ResponseManagedObjectExtractorList()
        requestRegistrator = RequestRegistrator(appContext: appContext)
        super.init()
    }

    deinit {
        //
    }

    // MARK: Public

    public func registerModelService(_ serviceClass: RequestModelServiceProtocol.Type) {
        requestRegistrator.registerServiceClass(serviceClass)
    }

}

// MARK: - RequestManager + RequestListenerProtocol

extension RequestManager: RequestListenerProtocol {

    public func request(_ request: RequestProtocol, startedWith _: URLRequest) {
        grouppedListenerList.didStartRequest(request, requestManager: self)
    }

    public func request(_ request: RequestProtocol, canceledWith _: Error?) {
        removeRequest(request)
    }

    public func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            removeRequest(request)
        }

        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
            return
        }

        do {
            try appContext.responseManager?.addListener(self, forRequest: request)
            let linker = linkerList.linkerForRequest(request)
            let extractor = extractorList.extractorForRequest(request)
            appContext.responseManager?.startWorkingOn(request, withData: data, linker: linker, extractor: extractor)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

}

extension RequestManager {

    private func removeRequest(_ request: RequestProtocol) {
        grouppedRequestList.removeRequest(request)
        request.removeListener(self)
    }

    private func removeExtractors(for request: RequestProtocol) {
        do {
            try extractorList.removeExtractorForRequest(request)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func removeLinkers(for request: RequestProtocol) {
        do {
            try linkerList.removeLinkerForRequest(request)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}

// MARK: - RequestManager + ResponseManagerListener

extension RequestManager: ResponseManagerListener {
    public func responseManager(_: ResponseManagerProtocol, didStartWorkOn _: RequestProtocol) {
        //
    }

    public func responseManager(_ responseManager: ResponseManagerProtocol, didFinishWorkOn request: RequestProtocol, withError error: Error?) {
        responseManager.removeListener(self, forRequest: request)
        grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)
        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
        }

        removeExtractors(for: request)
        removeLinkers(for: request)
        removeRequest(request)
    }

    public func responseManager(_ responseManager: ResponseManagerProtocol, didCancelWorkOn request: RequestProtocol, reason: ResponseCancelReasonProtocol) {
        responseManager.removeListener(self, forRequest: request)

        grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: reason.error)

        removeExtractors(for: request)
        removeLinkers(for: request)
        removeRequest(request)
    }

}

// MARK: - RequestManager + RequestManagerProtocol

extension RequestManager: RequestManagerProtocol {
    public func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol) {
        //
        grouppedRequestList.cancelRequests(groupId: groupId, reason: reason) { [weak self] request, reason in
            guard let self = self else { return }
            self.grouppedListenerList.didCancelRequest(request, requestManager: self, reason: reason)
        }
    }

    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        //
        grouppedListenerList.removeListener(listener)
    }

    public func createRequest(forRequestId: RequestIdType) throws -> RequestProtocol {
        //
        try requestRegistrator.createRequest(forRequestId: forRequestId)
    }

    public func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectLinker: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws {
        //
        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)

        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)
        } else {
            appContext.logInspector?.log(.warning(error: Errors.requestManagerListenerIsNil), sender: self)
        }

        try extractorList.addExtractor(managedObjectExtractor, forRequest: request)

        try linkerList.addLinker(managedObjectLinker, forRequest: request)

        try request.start()
    }

    public func fetchRemote(modelClass: FetchableProtocol.Type, contextPredicate: ContextPredicateProtocol?, managedObjectLinker: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws {
        let requestIDs = requestRegistrator.requestIds(modelServiceClass: modelClass)
        guard !requestIDs.isEmpty else {
            throw Errors.requestsNotRegistered(modelClass)
        }

        DispatchQueue.main.async {
            for requestID in requestIDs {
                do {
                    //
                    let request = try self.createRequest(modelClass: modelClass, requestID: requestID, contextPredicate: contextPredicate)
                    let groupId: RequestIdType = request.MD5.hashValue

                    try self.startRequest(request, forGroupId: groupId, managedObjectLinker: managedObjectLinker, managedObjectExtractor: managedObjectExtractor, listener: listener)
                } catch {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            }
        }
    }

    private func createRequest(modelClass: FetchableProtocol.Type, requestID: RequestIdType, contextPredicate: ContextPredicateProtocol?) throws -> RequestProtocol {
        let request = try requestRegistrator.createRequest(forRequestId: requestID)

        let builder = RequestArgumentsBuilder(modelClass: modelClass, contextPredicate: contextPredicate)
        let arguments = builder.buildRequestArguments(keypathPrefix: request.httpAPIQueryPrefix(), httpQueryItemName: request.httpQueryItemName)

        request.contextPredicate = contextPredicate
        request.arguments = arguments
        return request
    }
}

// MARK: - %t + RequestManager.Errors

extension RequestManager {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case adapterNotFound(RequestProtocol)
        case notAModelService(RequestProtocol)
        case noRequestIds(RequestProtocol)
        case requestNotCreated(RequestArgumentsBuilderProtocol)
        case requestsNotRegistered(FetchableProtocol.Type)
        case receivedResponseFromReleasedRequest
        case cantAddListener
        case invalidRequest
        case modelClassNotFound(RequestProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)
        case requestManagerListenerIsNil

        public var description: String {
            switch self {
            case .notAModelService(let request): return "\(type(of: self)): Not a model service: \(String(describing: request))"
            case .adapterNotFound(let request): return "\(type(of: self)): Adapter not found for request: \(String(describing: request))"
            case .noRequestIds(let request): return "\(type(of: self)): No request ids for request: \(String(describing: request))"
            case .receivedResponseFromReleasedRequest: return "\(type(of: self)): Received response from released request"
            case .requestNotCreated(let paradigm): return "\(type(of: self)): Request not created for [\(String(describing: paradigm))]"
            case .cantAddListener: return "\(type(of: self)): Can't add listener"
            case .invalidRequest: return "\(type(of: self)): Invalid request"
            case .modelClassNotFound(let request): return "\(type(of: self)): Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "\(type(of: self)): Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            case .requestManagerListenerIsNil: return "\(type(of: self)): RequestManagerListener is nil"
            case .requestsNotRegistered(let modelClass): return "[\(type(of: self))]: Request was not registered for [\(String(describing: modelClass))]"
            }
        }
    }
}

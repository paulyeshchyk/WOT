//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - RequestManager

@objc
open class RequestManager: NSObject {

    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & HostConfigurationContainerProtocol
        & ResponseDataAdapterCreatorContainerProtocol
        & DecoderManagerContainerProtocol

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

    public func registerModelService(_ serviceClass: ModelServiceProtocol.Type) {
        requestRegistrator.registerServiceClass(serviceClass)
    }
}

// MARK: - RequestManager + RequestListenerProtocol

extension RequestManager: RequestListenerProtocol {

    public func request(_ request: RequestProtocol, startedWith _: URLRequest) {
        grouppedListenerList.didStartRequest(request, requestManager: self)

        appContext.logInspector?.logEvent(EventRequestListenerStart(request, listener: self), sender: self)
    }

    public func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            appContext.logInspector?.logEvent(EventRequestListenerEnd(request, listener: self), sender: self)
            removeRequest(request)
        }

        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
            return
        }

        do {
            try parseResponse(request: request, data: data)
        } catch {
            grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func parseResponse(request: RequestProtocol, data: Data?) throws {
        guard let modelService = request as? ModelServiceProtocol else {
            throw Errors.modelNotFound(request)
        }

        guard let modelClass = type(of: modelService).modelClass() else {
            throw Errors.modelNotFound(request)
        }

        let dataAdapter = type(of: modelService).dataAdapterClass().init(appContext: appContext, modelClass: modelClass)
        dataAdapter.request = request
        dataAdapter.linker = linkerList.linkerForRequest(request)
        dataAdapter.extractor = extractorList.extractorForRequest(request)
        dataAdapter.completion = { request, error in
            self.finalizeParseResponse(request: request, error: error)
        }
        dataAdapter.decode(data: data, fromRequest: request)
    }

    private func finalizeParseResponse(request: RequestProtocol, error: Error?) {
        //
        grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)
        //

        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
        }
        //
        do {
            try extractorList.removeExtractorForRequest(request)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }

        do {
            try linkerList.removeLinkerForRequest(request)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    public func request(_ request: RequestProtocol, canceledWith: Error?) {
        appContext.logInspector?.logEvent(EventRequestListenerCancel(request, listener: self, error: canceledWith), sender: self)
        removeRequest(request)
    }

    private func removeRequest(_ request: RequestProtocol) {
        grouppedRequestList.removeRequest(request)
        request.removeListener(self)
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

    public func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectCreator: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws {
        //
        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)

        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)
        } else {
            appContext.logInspector?.log(.warning(error: Errors.requestManagerListenerIsNil), sender: self)
        }

        try extractorList.addExtractor(managedObjectExtractor, forRequest: request)

        try linkerList.addLinker(managedObjectCreator, forRequest: request)

        try request.start()
    }

    public func fetchRemote(modelClass: RequestableProtocol.Type, contextPredicate: ContextPredicateProtocol?, managedObjectLinker: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws {
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

                    try self.startRequest(request, forGroupId: groupId, managedObjectCreator: managedObjectLinker, managedObjectExtractor: managedObjectExtractor, listener: listener)
                } catch {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            }
        }
    }

    private func createRequest(modelClass: RequestableProtocol.Type, requestID: RequestIdType, contextPredicate: ContextPredicateProtocol?) throws -> RequestProtocol {
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
        case modelNotFound(RequestProtocol)
        case notAModelService(RequestProtocol)
        case noRequestIds(RequestProtocol)
        case requestNotCreated(RequestArgumentsBuilderProtocol)
        case requestsNotRegistered(RequestableProtocol.Type)
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
            case .modelNotFound(let request): return "\(type(of: self)): Model not found for request: \(String(describing: request))"
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

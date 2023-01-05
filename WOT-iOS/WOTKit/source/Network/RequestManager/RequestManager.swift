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

    deinit {
        //
    }

    public required init(appContext: Context) {
        self.appContext = appContext
        grouppedRequestList = RequestGrouppedRequestList(appContext: appContext)
        grouppedListenerList = RequestGrouppedListenerList()
        managedObjectCreatorList = ResponseManagedObjectCreatorList()
        managedObjectExractableList = ResponseManagedObjectExtractableList()
        requestRegistrator = RequestRegistrator(appContext: appContext)
        super.init()
    }

    public typealias Context =
        LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol & HostConfigurationContainerProtocol & ResponseDataAdapterCreatorContainerProtocol

    override public var description: String { String(describing: type(of: self)) }

    public var MD5: String { uuid.MD5 }

    public func registerModelService(_ serviceClass: ModelServiceProtocol.Type) {
        requestRegistrator.registerServiceClass(serviceClass)
    }

    private let uuid = UUID()
    private let appContext: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList
    private let managedObjectCreatorList: ResponseManagedObjectCreatorList
    private let managedObjectExractableList: ResponseManagedObjectExtractableList

    private let requestRegistrator: RequestRegistratorProtocol
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
            appContext.logInspector?.log(.error(error))
            return
        }

        do {
            try parseResponse(request: request, data: data)
        } catch {
            grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)
            appContext.logInspector?.log(.error(error))
        }
    }

    private func parseResponse(request: RequestProtocol, data: Data?) throws {
        guard let managedObjectCreator = managedObjectCreatorList.adapterLinkerForRequest(request) else {
            throw RequestManagerError.adapterNotFound(request)
        }

        guard let modelService = request as? ModelServiceProtocol else {
            throw RequestManagerError.modelNotFound(request)
        }

        guard let modelClass = type(of: modelService).modelClass() else {
            throw RequestManagerError.modelNotFound(request)
        }

        guard let managedObjectExtractor = managedObjectExractableList.extractorForRequest(request) else {
            throw RequestManagerError.extractorNotFound(request)
        }

        let dataAdapter = type(of: modelService).dataAdapterClass().init(modelClass: modelClass, request: request, managedObjectLinker: managedObjectCreator, jsonExtractor: managedObjectExtractor, appContext: appContext)

        dataAdapter.decode(data: data, fromRequest: request) { [weak self] request, error in
            guard let self = self else {
                return
            }
            self.grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)

            do {
                try self.managedObjectExractableList.removeExtractorForRequest(request)
            } catch {
                self.appContext.logInspector?.log(.error(error))
            }

            do {
                try self.managedObjectCreatorList.removeAdapterForRequest(request)
            } catch {
                self.appContext.logInspector?.log(.error(error))
            }
        }
    }

    private func finalizeParseResponse(request _: RequestProtocol) {}

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
            appContext.logInspector?.log(.warning(error: RequestManagerError.requestManagerListenerIsNil))
        }

        try managedObjectExractableList.addExtractor(managedObjectExtractor, forRequest: request)

        try managedObjectCreatorList.addAdapterLinker(managedObjectCreator, forRequest: request)

        try request.start { [weak self] in

            self?.appContext.logInspector?.log(.custom("Start"))
        }
    }

    public func fetchRemote(requestParadigm: RequestParadigmProtocol, managedObjectLinker: ManagedObjectLinkerProtocol, managedObjectExtractor: ManagedObjectExtractable, listener: RequestManagerListenerProtocol?) throws {
        //
        let requestIDs = requestRegistrator.requestIds(modelServiceClass: requestParadigm.modelClass)
        guard !requestIDs.isEmpty else {
            throw RequestManagerError.requestsNotRegistered(requestParadigm)
        }
        for requestID in requestIDs {
            do {
                //
                let request = try requestRegistrator.createRequest(forRequestId: requestID)
                request.contextPredicate = requestParadigm.buildContextPredicate()
                request.arguments = requestParadigm.buildRequestArguments()
                let groupId: RequestIdType = requestParadigm.MD5.hashValue

                try startRequest(request, forGroupId: groupId, managedObjectCreator: managedObjectLinker, managedObjectExtractor: managedObjectExtractor, listener: listener)
            } catch {
                appContext.logInspector?.log(.error(error))
            }
        }
    }
}

// MARK: - ResponseManagedObjectCreatorList

private class ResponseManagedObjectCreatorList {

    func addAdapterLinker(_ adapter: ManagedObjectLinkerProtocol, forRequest: RequestProtocol) throws {
        adaptersLinkerList[forRequest.MD5] = adapter
    }

    func adapterLinkerForRequest(_ request: RequestProtocol) -> ManagedObjectLinkerProtocol? {
        adaptersLinkerList[request.MD5]
    }

    func removeAdapterForRequest(_ request: RequestProtocol) throws {
        let value = adaptersLinkerList.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw AdapterLinkerListError.notRemoved(request)
        }
    }

    private enum AdapterLinkerListError: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(ManagedObjectLinkerProtocol)

        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Adapter was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Adapter was not found for \(String(describing: adapterLinker))"
            }
        }
    }

    private var adaptersLinkerList: [AnyHashable: ManagedObjectLinkerProtocol] = [:]
}

// MARK: - ResponseManagedObjectExtractableList

private class ResponseManagedObjectExtractableList {

    func addExtractor(_ adapter: ManagedObjectExtractable, forRequest: RequestProtocol) throws {
        extractorList[forRequest.MD5] = adapter
    }

    func extractorForRequest(_ request: RequestProtocol) -> ManagedObjectExtractable? {
        extractorList[request.MD5]
    }

    func removeExtractorForRequest(_ request: RequestProtocol) throws {
        let value = extractorList.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw ExtractorLinkerListError.notRemoved(request)
        }
    }

    private enum ExtractorLinkerListError: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(ManagedObjectLinkerProtocol)

        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Extractor was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Extractor was not found for \(String(describing: adapterLinker))"
            }
        }
    }

    private var extractorList: [AnyHashable: ManagedObjectExtractable] = [:]
}

// MARK: - RequestGrouppedListenerList

private class RequestGrouppedListenerList {

    func didStartRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol) {
        grouppedListeners[request.MD5]?.forEach {
            $0.requestManager(requestManager, didStartRequest: request)
        }
    }

    func didCancelRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, reason: RequestCancelReasonProtocol) {
        grouppedListeners[request.MD5]?.forEach {
            $0.requestManager(requestManager, didCancelRequest: request, reason: reason)
        }
    }

    func didParseDataForRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, error: Error?) {
        grouppedListeners[request.MD5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, error: error)
        }
    }

    func addListener(_ listener: RequestManagerListenerProtocol, forRequest: RequestProtocol) throws {
        let requestMD5 = forRequest.MD5
        if var listeners = grouppedListeners[requestMD5] {
            let filtered = listeners.filter { $0.MD5 == listener.MD5 }
            guard filtered.isEmpty else {
                throw GrouppedListenersError.dublicate
            }
            listeners.append(listener)
            grouppedListeners[requestMD5] = listeners
        } else {
            grouppedListeners[requestMD5] = [listener]
        }
    }

    func removeListener(_ listener: RequestManagerListenerProtocol) {
        for MD5 in grouppedListeners.keys {
            if var listeners = grouppedListeners[MD5] {
                listeners.removeAll(where: { $0.MD5 == listener.MD5 })
                grouppedListeners[MD5] = listeners
            }
        }
    }

    private enum GrouppedListenersError: Error, CustomStringConvertible {
        case dublicate

        var description: String {
            switch self {
            case .dublicate: return "[\(type(of: self))]: Dublicate"
            }
        }
    }

    private var grouppedListeners = [AnyHashable: [RequestManagerListenerProtocol]]()
}

// MARK: - RequestGrouppedRequestList

private class RequestGrouppedRequestList {

    init(appContext: Context) {
        self.appContext = appContext
    }

    typealias Context = LogInspectorContainerProtocol

    typealias CancelCompletion = (RequestProtocol, RequestCancelReasonProtocol) -> Void

    func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) throws {
        if grouppedRequests.keys.isEmpty {
            appContext.logInspector?.log(.flow(name: "group", message: "Start: <\(String(describing: request))>"))
        }

        var requestsForID: [RequestProtocol] = []
        if let available = grouppedRequests[groupId] {
            requestsForID.append(contentsOf: available)
        }
        let filtered = requestsForID.filter { $0.MD5 == request.MD5 }
        guard filtered.isEmpty else {
            throw GrouppedRequestListenersError.dublicate
        }
        request.addGroup(groupId)
        requestsForID.append(request)
        grouppedRequests[groupId] = requestsForID
    }

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol, completion: @escaping CancelCompletion) {
        guard let requests = grouppedRequests[groupId]?.compactMap({ $0 }), !requests.isEmpty else {
            return
        }
        for request in requests {
            do {
                try request.cancel(byReason: reason)
            } catch {
                appContext.logInspector?.log(.warning(error: error))
            }
            completion(request, reason)
        }
    }

    func removeRequest(_ request: RequestProtocol) {
        for group in request.availableInGroups {
            if var grouppedRequests = grouppedRequests[group] {
                let cnt = grouppedRequests.count
                grouppedRequests.removeAll(where: { $0.MD5 == request.MD5 })
                assert(grouppedRequests.count != cnt, "not removed")
                if grouppedRequests.isEmpty {
                    self.grouppedRequests.removeValue(forKey: group)
                } else {
                    self.grouppedRequests[group] = grouppedRequests
                }
            }
        }
        if grouppedRequests.keys.isEmpty {
            appContext.logInspector?.log(.flow(name: "group", message: "End: <\(String(describing: request))>"))
        }
    }

    private enum GrouppedRequestListenersError: Error, CustomStringConvertible {
        case dublicate

        var description: String {
            switch self {
            case .dublicate: return "[\(type(of: self))]: Dublicate"
            }
        }
    }

    private var grouppedRequests: [RequestIdType: [RequestProtocol]] = [:]

    private let appContext: Context
}

// MARK: - RequestManagerError

private enum RequestManagerError: Error, CustomStringConvertible {
    case extractorNotFound(RequestProtocol)
    case adapterNotFound(RequestProtocol)
    case modelNotFound(RequestProtocol)
    case notAModelService(RequestProtocol)
    case noRequestIds(RequestProtocol)
    case requestNotCreated(RequestParadigmProtocol)
    case requestsNotRegistered(RequestParadigmProtocol)
    case receivedResponseFromReleasedRequest
    case cantAddListener
    case invalidRequest
    case modelClassNotFound(RequestProtocol)
    case modelClassNotRegistered(AnyObject, RequestProtocol)
    case requestManagerListenerIsNil

    public var description: String {
        switch self {
        case .extractorNotFound(let request): return "\(type(of: self)): Extractor not found for request: \(String(describing: request))"
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
        case .requestsNotRegistered(let paradigm): return "[\(type(of: self))]: Request was not registered for [\(String(describing: paradigm))]"
        }
    }
}

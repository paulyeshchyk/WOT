//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
open class RequestManager: NSObject {
    public typealias Context =
        LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol & HostConfigurationContainerProtocol & ResponseDataAdapterCreatorContainerProtocol

    override public var description: String { String(describing: type(of: self)) }

    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    private let appContext: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList
    private let managedObjectCreatorList: ResponseManagedObjectCreatorList

    private let requestRegistrator: RequestRegistratorProtocol
    deinit {
        //
    }

    public required init(appContext: Context) {
        self.appContext = appContext
        grouppedRequestList = RequestGrouppedRequestList(appContext: appContext)
        grouppedListenerList = RequestGrouppedListenerList()
        managedObjectCreatorList = ResponseManagedObjectCreatorList()
        requestRegistrator = RequestRegistrator(appContext: appContext)
        super.init()
    }

    public func registerModelService(_ serviceClass: ModelServiceProtocol.Type) {
        requestRegistrator.registerServiceClass(serviceClass)
    }
}

extension RequestManager: RequestListenerProtocol {
    // MARK: - RequestListenerProtocol

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
            appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
            return
        }

        do {
            guard let managedObjectCreator = managedObjectCreatorList.adapterLinkerForRequest(request) else {
                throw RequestManagerError.adapterNotFound(request)
            }

            guard let modelService = request as? ModelServiceProtocol else {
                throw RequestManagerError.modelNotFound(request)
            }

            guard let modelClass = type(of: modelService).modelClass() else {
                throw RequestManagerError.modelNotFound(request)
            }
            let dataAdapters = type(of: modelService).dataAdapterClass().init(modelClass: modelClass, request: request, managedObjectCreator: managedObjectCreator, appContext: appContext)
            let responseParser = type(of: modelService).responseParserClass().init(appContext: appContext)

            try responseParser.parseResponse(data: data, forRequest: request, dataAdapter: dataAdapters, completion: {[weak self] request, error in
                guard let self = self else {
                    return
                }
                if let error = error {
                    self.appContext.logInspector?.logEvent(EventError(error, details: self), sender: self)
                    return
                }
                do {
                    try self.managedObjectCreatorList.removeAdapterForRequest(request)
                } catch {
                    self.appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }

                if let error = error {
                    self.appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
                do {
                    try self.grouppedListenerList.didParseDataForRequest(request, requestManager: self, completionType: .finished)
                } catch {
                    self.appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.logEvent(EventError(error, details: String(describing: request)), sender: self)
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

// MARK: - RequestManagerProtocol

extension RequestManager: RequestManagerProtocol {
    public func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol) {
        //
        appContext.logInspector?.logEvent(EventRequestManagerFetchCancel("\(String(describing: reason))"), sender: self)
        grouppedRequestList.cancelRequests(groupId: groupId, reason: reason) {[weak self] request, reason in
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

    public func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectCreator: ManagedObjectCreatorProtocol, listener: RequestManagerListenerProtocol?) throws {
        //
        appContext.logInspector?.logEvent(EventRequestManagerFetchStart("\(String(describing: request.arguments))"), sender: self)

        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)

        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)

        } else {
            let event = EventWarning(error: RequestManagerError.requestManagerListenerIsNil, details: nil)
            appContext.logInspector?.logEvent(event, sender: self)
        }

        try managedObjectCreatorList.addAdapterLinker(managedObjectCreator, forRequest: request)

        try request.start { [weak self] in
            self?.appContext.logInspector?.logEvent(EventRequestManagerFetchEnd("\(String(describing: request.arguments))"), sender: self)
        }
    }

    public func fetchRemote(requestParadigm: RequestParadigmProtocol, managedObjectCreator: ManagedObjectCreatorProtocol, listener: RequestManagerListenerProtocol?) throws {
        //
        let requestIDs = requestRegistrator.requestIds(modelServiceClass: requestParadigm.modelClass)
        guard !requestIDs.isEmpty else {
            throw RequestManagerError.requestsNotRegistered(requestParadigm)
        }
        for requestID in requestIDs {
            do {
                //
                let request = try requestRegistrator.createRequest(forRequestId: requestID)
                request.contextPredicate = try requestParadigm.buildContextPredicate()
                request.arguments = requestParadigm.buildRequestArguments()
                let groupId: RequestIdType = requestParadigm.MD5.hashValue

                try startRequest(request, forGroupId: groupId, managedObjectCreator: managedObjectCreator, listener: listener)
            } catch {
                appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}

private class ResponseManagedObjectCreatorList {
    private enum AdapterLinkerListError: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(ManagedObjectCreatorProtocol)
        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Adapter was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Adapter was not found for \(String(describing: adapterLinker))"
            }
        }
    }

    private var adaptersLinkerList: [AnyHashable: ManagedObjectCreatorProtocol] = [:]

    func addAdapterLinker(_ adapter: ManagedObjectCreatorProtocol, forRequest: RequestProtocol) throws {
        adaptersLinkerList[forRequest.MD5] = adapter
    }

    func adapterLinkerForRequest(_ request: RequestProtocol) -> ManagedObjectCreatorProtocol? {
        adaptersLinkerList[request.MD5]
    }

    func removeAdapterForRequest(_ request: RequestProtocol) throws {
        let value = adaptersLinkerList.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw AdapterLinkerListError.notRemoved(request)
        }
    }
}

private class RequestGrouppedListenerList {
    private enum GrouppedListenersError: Error, CustomStringConvertible {
        case dublicate
        var description: String {
            switch self {
            case .dublicate: return "[\(type(of: self))]: Dublicate"
            }
        }
    }

    private var grouppedListeners = [AnyHashable: [RequestManagerListenerProtocol]]()

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

    func didParseDataForRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, completionType: WOTRequestManagerCompletionResultType) throws {
        grouppedListeners[request.MD5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, completionResultType: completionType)
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
}

private class RequestGrouppedRequestList {
    typealias Context = LogInspectorContainerProtocol

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
    init(appContext: Context) {
        self.appContext = appContext
    }

    func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) throws {
        if grouppedRequests.keys.isEmpty {
            appContext.logInspector?.logEvent(EventLongTermStart("\(String(describing: request))"), sender: self)
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

    typealias CancelCompletion = (RequestProtocol, RequestCancelReasonProtocol) -> Void

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol, completion: @escaping CancelCompletion) {
        guard let requests = grouppedRequests[groupId]?.compactMap({ $0 }), !requests.isEmpty else {
            return
        }
        for request in requests {
            do {
                try request.cancel(byReason: reason)
            } catch {
                appContext.logInspector?.logEvent(EventWarning(error: error, details: "Request cancelation"), sender: self)
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
            appContext.logInspector?.logEvent(EventLongTermEnd("\(String(describing: request))"), sender: self)
        }
    }
}

private enum RequestManagerError: Error, CustomStringConvertible {
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

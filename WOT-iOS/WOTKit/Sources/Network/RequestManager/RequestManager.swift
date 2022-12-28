//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class RequestManager: NSObject, RequestListenerProtocol {
    private enum RequestManagerError: Error, CustomStringConvertible {
        case adapterNotFound(RequestProtocol)
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
            case .adapterNotFound(let request): return "\(type(of: self)): Linker not found for request: \(String(describing: request))"
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

    public typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseDataAdapterCreatorContainerProtocol

    override public var description: String { String(describing: type(of: self)) }

    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    private let appContext: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList
    private let managedObjectCreatorList: ResponseManagedObjectCreatorList

    deinit {
        //
    }

    public required init(appContext: Context) {
        self.appContext = appContext
        self.grouppedRequestList  = RequestGrouppedRequestList(appContext: appContext)
        self.grouppedListenerList = RequestGrouppedListenerList()
        self.managedObjectCreatorList = ResponseManagedObjectCreatorList()
        super.init()
    }

    // MARK: - WOTRequestListenerProtocol

    public func request(_ request: RequestProtocol, startedWith urlRequest: URLRequest) {
        grouppedListenerList.didStartRequest(request, requestManager: self)

        appContext.logInspector?.logEvent(EventWEBStart(request), sender: self)
    }

    public func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            appContext.logInspector?.logEvent(EventWEBEnd(request), sender: self)
            removeRequest(request)
        }

        if let error = error {
            appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
            return
        }

        do {
            #warning("move to response parser")
            guard let managedObjectCreator = managedObjectCreatorList.adapterLinkerForRequest(request) else {
                throw RequestManagerError.adapterNotFound(request)
            }
            guard let requestIds = try appContext.requestRegistrator?.requestIds(forRequest: request) else {
                throw RequestManagerError.noRequestIds(request)
            }
            #warning("move to response parser")
            let dataAdapters = appContext.responseDataAdapterCreator?.responseDataAdapterInstances(byRequestIdTypes: requestIds, request: request, managedObjectCreator: managedObjectCreator)

            let responseParser = request.responseParserClass.init(appContext: appContext)

            try responseParser.parseResponse(data: data, forRequest: request, dataAdapters: dataAdapters, completion: {[weak self] request, error in
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
        appContext.logInspector?.logEvent(EventWEBCancel(request, error: canceledWith), sender: self)
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
        grouppedRequestList.cancelRequests(groupId: groupId, reason: reason)
    }

    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        grouppedListenerList.removeListener(listener)
    }

    public func startRequest(_ request: RequestProtocol, forGroupId: RequestIdType, managedObjectCreator: ManagedObjectCreatorProtocol, listener: RequestManagerListenerProtocol?) throws {
        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)

        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)

        } else {
            let event = EventWarning(error: RequestManagerError.requestManagerListenerIsNil, details: nil)
            appContext.logInspector?.logEvent(event, sender: self)
        }

        try managedObjectCreatorList.addAdapterLinker(managedObjectCreator, forRequest: request)

        try request.start()
    }

    public func fetchRemote(requestParadigm: RequestParadigmProtocol, requestPredicateComposer: RequestPredicateComposerProtocol, managedObjectCreator: ManagedObjectCreatorProtocol, listener: RequestManagerListenerProtocol?) throws {
        guard let requestIDs = appContext.requestRegistrator?.requestIds(modelServiceClass: requestParadigm.modelClass), !requestIDs.isEmpty else {
            throw RequestManagerError.requestsNotRegistered(requestParadigm)
        }
        for requestID in requestIDs {
            do {
                guard let request = try appContext.requestRegistrator?.createRequest(forRequestId: requestID) else {
                    throw RequestManagerError.requestNotCreated(requestParadigm)
                }
                request.contextPredicate = requestPredicateComposer.build()?.requestPredicate
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

    func didParseDataForRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, completionType: WOTRequestManagerCompletionResultType) throws {
        grouppedListeners[request.MD5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, completionResultType: completionType)
        }
    }

    func addListener(_ listener: RequestManagerListenerProtocol, forRequest: RequestProtocol) throws {
        let requestMD5 = forRequest.MD5
        if var listeners = grouppedListeners[requestMD5] {
            let filtered = listeners.filter({ $0.MD5 == listener.MD5 })
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
        var requestsForID: [RequestProtocol] = []
        if let available = self.grouppedRequests[groupId] {
            requestsForID.append(contentsOf: available)
        }
        let filtered = requestsForID.filter { $0.MD5 == request.MD5 }
        guard filtered.isEmpty else {
            throw GrouppedRequestListenersError.dublicate
        }
        request.addGroup(groupId)
        requestsForID.append(request)
        self.grouppedRequests[groupId] = requestsForID
    }

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol) {
        guard let requests = grouppedRequests[groupId]?.compactMap({ $0 }), !requests.isEmpty else {
            return
        }
        for request in requests {
            do {
                try request.cancel(byReason: reason)
            } catch {}
        }
    }

    func removeRequest(_ request: RequestProtocol) {
        for group in request.availableInGroups {
            if var grouppedRequests = self.grouppedRequests[group] {
                let cnt = grouppedRequests.count
                grouppedRequests.removeAll(where: { $0.MD5 == request.MD5 })
                assert(grouppedRequests.count != cnt, "not removed")
                self.grouppedRequests[group] = grouppedRequests
            }
        }
    }
}

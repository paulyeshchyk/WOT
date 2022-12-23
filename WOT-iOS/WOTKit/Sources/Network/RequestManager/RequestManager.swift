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
    
    private enum RequestManagerError: Error {
        case adapterNotFound(RequestProtocol)
        case noRequestIds(RequestProtocol)
        case requestNotFound
        case receivedResponseFromReleasedRequest
        case cantAddListener
        case invalidRequest
        case modelClassNotFound(RequestProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)
        public var debugDescription: String {
            switch self {
            case .adapterNotFound(let request): return "Linker not found for request: \(String(describing: request))"
            case .noRequestIds(let request): return "No request ids for request: \(String(describing: request))"
            case .receivedResponseFromReleasedRequest: return "Received response from released request"
            case .requestNotFound: return "Request not found"
            case .cantAddListener: return "Can't add listener"
            case .invalidRequest: return "Invalid request"
            case .modelClassNotFound(let request): return "Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            }
        }
    }
    
    public typealias Context = ResponseParserContainerProtocol & LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseAdapterCreatorContainerProtocol
    
    override public var description: String { String(describing: type(of: self)) }
    
    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    private let context: Context

    private let grouppedListenerList = RequestGrouppedListenerList()
    private let grouppedRequestList = RequestGrouppedRequestList()
    private let adapterLinkerList = ResponseAdapterLinkerList()

    deinit {
        //
    }

    public required init(context: Context) {
        self.context = context
        super.init()
    }

// MARK: - WOTRequestListenerProtocol

    public func request(_ request: RequestProtocol, startedWith urlRequest: URLRequest) {

        grouppedListenerList.didStartRequest(request, requestManager: self)

        context.logInspector?.logEvent(EventWEBStart(request), sender: self)
    }

    public func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            context.logInspector?.logEvent(EventWEBEnd(request), sender: self)
            removeRequest(request)
        }

        if let error = error {
            context.logInspector?.logEvent(EventError(error, details: request), sender: self)
            return
        }

        do {
         
            guard let grouppedLinker = adapterLinkerList.adapterForRequest(request) else {
                throw RequestManagerError.adapterNotFound(request)
            }
            guard let requestIds = try context.requestRegistrator?.requestIds(forRequest: request) else {
                throw RequestManagerError.noRequestIds(request)
            }
            let adapters = context.responseAdapterCreator?.responseAdapterInstances(byRequestIdTypes: requestIds, request: request, jsonAdapterLinker: grouppedLinker, requestManager: self)

            try context.responseParser?.parseResponse(data: data, forRequest: request, adapters: adapters, completion: {[weak self] request, error in
                guard let self = self else {
                    return
                }
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: self), sender: self)
                    return
                }
                guard let request = request else {
                    self.context.logInspector?.logEvent(EventError(RequestManagerError.receivedResponseFromReleasedRequest, details: self), sender: self)
                    return
                }
                
                do {
                    try self.adapterLinkerList.removeAdapterForRequest(request)
                } catch {
                    self.context.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
                
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
                do {
                    try self.grouppedListenerList.didParseDataForRequest(request, requestManager: self, completionType: .finished)
                } catch {
                    self.context.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
            })
        } catch {
            context.logInspector?.logEvent(EventError(error, details: String(describing: request)), sender: self)
        }
    }

    public func request(_ request: RequestProtocol, canceledWith error: Error?) {
        context.logInspector?.logEvent(EventWEBCancel(request), sender: self)
        removeRequest(request)
    }

    private func removeRequest(_ request: RequestProtocol) {
        grouppedRequestList.removeRequest(request)
        request.removeListener(self)
    }
}
// MARK: - RequestManagerProtocol

extension RequestManager: RequestManagerProtocol {

    public func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol {
        guard let Clazz = context.requestRegistrator?.requestClass(for: requestId) as? RequestProtocol.Type else {
            throw RequestManagerError.requestNotFound
        }
        return Clazz.init(context: context)
    }

    public func cancelRequests(groupId: RequestIdType, with error: Error?) {
        grouppedRequestList.cancelRequests(groupId: groupId, with: error)
    }

    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        grouppedListenerList.removeListener(listener)
    }

    public func startRequest(_ request: RequestProtocol, withArguments: RequestArgumentsProtocol, forGroupId: RequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws {

        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)
        
        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)

        } else {
            context.logInspector?.logEvent(EventWarning(message: "request listener is nil"), sender: self)
        }

        try adapterLinkerList.addAdapterLinker(jsonAdapterLinker, forRequest: request)

        try request.start(withArguments: withArguments)
    }

    public func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws {
        let request = try createRequest(forRequestId: requestId)
        request.paradigm = paradigm

        let arguments = paradigm.buildRequestArguments()
        let jsonAdapterLinker = paradigm.jsonAdapterLinker
        let groupId = "Nested\(String(describing: paradigm.clazz))-\(arguments)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, jsonAdapterLinker: jsonAdapterLinker, listener: nil)
    }
    
    public func fetchRemote(paradigm: MappingParadigmProtocol) {
        guard let requestIDs = context.requestRegistrator?.requestIds(forClass: paradigm.clazz), requestIDs.count > 0 else {
            context.logInspector?.logEvent(EventError(WOTFetcherError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try startRequest(by: $0, paradigm: paradigm)
            } catch {
                context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}

private class ResponseAdapterLinkerList {
    
    private enum AdapterLinkerListError: Error {
        case notRemoved(RequestProtocol)
        case notFound(JSONAdapterLinkerProtocol)
        var debugDescription: String {
            switch self {
            case .notRemoved(let request): return "Adapter was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "Adapter was not found for \(String(describing: adapterLinker))"
            }
        }
    }
    private var adaptersLinkerList: [AnyHashable: JSONAdapterLinkerProtocol] = [:]
    
    func addAdapterLinker(_ adapter: JSONAdapterLinkerProtocol, forRequest: RequestProtocol) throws {
        adaptersLinkerList[forRequest.MD5] = adapter
    }
    
    func adapterForRequest(_ request: RequestProtocol) -> JSONAdapterLinkerProtocol? {
        adaptersLinkerList[request.MD5]
    }
    
    func removeAdapterForRequest(_ request: RequestProtocol) throws {
        let value = adaptersLinkerList.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw AdapterLinkerListError.notRemoved(request)
        }
    }
    
    func removeAdapter(_ adapterLinker: JSONAdapterLinkerProtocol) throws {
        guard let key = findKey(for: adapterLinker) else {
            throw AdapterLinkerListError.notFound(adapterLinker)
        }
        adaptersLinkerList.removeValue(forKey: key)
    }
    
    private func findKey(for adapterLinker: JSONAdapterLinkerProtocol) -> AnyHashable? {
        for key in adaptersLinkerList.keys {
            if adaptersLinkerList[key]?.MD5 == adapterLinker.MD5 {
                return key
            }
        }
        return nil
    }
}

private class RequestGrouppedListenerList {
    
    private enum GrouppedListenersError: Error {
        case dublicate
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
            guard filtered.count == 0 else {
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

    private enum GrouppedRequestListenersError: Error {
        case dublicate
    }
    
    private var grouppedRequests: [RequestIdType: [RequestProtocol]] = [:]
    
    func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) throws {
        var grouppedRequests: [RequestProtocol] = []
        if let available = self.grouppedRequests[groupId] {
            grouppedRequests.append(contentsOf: available)
        }
        let filtered = grouppedRequests.filter { $0.MD5 == request.MD5 }
        guard filtered.count == 0 else {
            throw GrouppedRequestListenersError.dublicate
        }
        request.addGroup(groupId)
        grouppedRequests.append(request)
        self.grouppedRequests[groupId] = grouppedRequests
    }
    
    func cancelRequests(groupId: RequestIdType, with error: Error?) {
        grouppedRequests[groupId]?.forEach { $0.cancel(with: error) }
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

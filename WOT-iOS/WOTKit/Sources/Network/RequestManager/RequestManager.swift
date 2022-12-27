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
        case requestNotFound
        case requestsNotParsed
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
            case .requestNotFound: return "\(type(of: self)): Request not found"
            case .cantAddListener: return "\(type(of: self)): Can't add listener"
            case .invalidRequest: return "\(type(of: self)): Invalid request"
            case .modelClassNotFound(let request): return "\(type(of: self)): Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "\(type(of: self)): Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            case .requestManagerListenerIsNil: return "\(type(of: self)): RequestManagerListener is nil"
            case .requestsNotParsed: return "[\(type(of: self))]: request is not parsed"
            }
        }
    }
    
    public typealias Context = ResponseParserContainerProtocol & LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseAdapterCreatorContainerProtocol
    
    override public var description: String { String(describing: type(of: self)) }
    
    public var MD5: String { uuid.MD5 }
    public let uuid: UUID = UUID()

    private let context: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList
    private let adapterLinkerList: ResponseAdapterLinkerList

    deinit {
        //
    }

    public required init(context: Context) {
        self.context = context
        self.grouppedRequestList  = RequestGrouppedRequestList(context: context)
        self.grouppedListenerList = RequestGrouppedListenerList()
        self.adapterLinkerList = ResponseAdapterLinkerList()
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
            guard let adapterLinker = adapterLinkerList.adapterLinkerForRequest(request) else {
                throw RequestManagerError.adapterNotFound(request)
            }
            guard let requestIds = try context.requestRegistrator?.requestIds(forRequest: request) else {
                throw RequestManagerError.noRequestIds(request)
            }
            let adapters = context.responseAdapterCreator?.responseAdapterInstances(byRequestIdTypes: requestIds, request: request, adapterLinker: adapterLinker, requestManager: self)

            try context.responseParser?.parseResponse(data: data, forRequest: request, adapters: adapters, completion: {[weak self] request, error in
                guard let self = self else {
                    return
                }
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: self), sender: self)
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

    public func request(_ request: RequestProtocol, canceledWith: Error?) {
        context.logInspector?.logEvent(EventWEBCancel(request, error: canceledWith), sender: self)
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

    public func startRequest(_ request: RequestProtocol, withArguments: RequestArgumentsProtocol, forGroupId: RequestIdType, adapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?, mappingParadigm: RequestParadigmProtocol?) throws {

        try grouppedRequestList.addRequest(request, forGroupId: forGroupId)
        
        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)

        } else {
            let event = EventWarning(error: RequestManagerError.requestManagerListenerIsNil, details: nil)
            context.logInspector?.logEvent(event, sender: self)
        }

        try adapterLinkerList.addAdapterLinker(adapterLinker, forRequest: request)

        try request.start(withArguments: withArguments)
    }

    private func startRequest(by requestId: RequestIdType, requestArgumentsBuilder: RequestParadigmProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws {
        guard let request = try context.requestRegistrator?.createRequest(forRequestId: requestId) else {
            throw RequestManagerError.requestNotFound
        }
        request.paradigm = requestArgumentsBuilder

        let arguments = requestArgumentsBuilder.buildRequestArguments()
//        let jsonAdapterLinker = requestArgumentsBuilder.jsonAdapterLinker
        #warning ("remove hashValue")
        let groupId: RequestIdType = "Nested\(String(describing: requestArgumentsBuilder.clazz))-\(arguments)".hashValue
        try startRequest(request, withArguments: arguments, forGroupId: groupId, adapterLinker: jsonAdapterLinker, listener: listener, mappingParadigm: requestArgumentsBuilder)
    }
    
    public func fetchRemote(mappingParadigm: RequestParadigmProtocol, jsonAdapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws {
        guard let requestIDs = context.requestRegistrator?.requestIds(forClass: mappingParadigm.clazz), requestIDs.count > 0 else {
            throw RequestManagerError.requestsNotParsed
        }
        for requestID in requestIDs {
            do {
                try startRequest(by: requestID, requestArgumentsBuilder: mappingParadigm, jsonAdapterLinker: jsonAdapterLinker, listener: listener)
            } catch {
                context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}

private class ResponseAdapterLinkerList {
    
    private enum AdapterLinkerListError: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(JSONAdapterLinkerProtocol)
        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Adapter was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Adapter was not found for \(String(describing: adapterLinker))"
            }
        }
    }
    private var adaptersLinkerList: [AnyHashable: JSONAdapterLinkerProtocol] = [:]
    
    func addAdapterLinker(_ adapter: JSONAdapterLinkerProtocol, forRequest: RequestProtocol) throws {
        adaptersLinkerList[forRequest.MD5] = adapter
    }
    
    func adapterLinkerForRequest(_ request: RequestProtocol) -> JSONAdapterLinkerProtocol? {
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
    
    private let context: Context
    init (context: Context) {
        self.context = context
    }
    
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
    
    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol) {
        guard let requests = grouppedRequests[groupId]?.compactMap({ $0 }), requests.count > 0 else {
            return
        }
        for request in requests {
            do {
                try request.cancel(byReason: reason)
            } catch {
                
            }
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

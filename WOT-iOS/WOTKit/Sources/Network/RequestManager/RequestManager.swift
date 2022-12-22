//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class RequestManager: NSObject {
    
    private enum RequestManagerError: Error {
        case adapterNotFound(RequestProtocol)
        case requestWasNotAddedToGroup
        case requestNotFound
        case receivedResponseFromReleasedRequest
        case cantAddListener
        case invalidRequest
        case modelClassNotFound(RequestProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)
        public var debugDescription: String {
            switch self {
            case .adapterNotFound(let request): return "Linker not found for request: \(String(describing: request))"
            case .receivedResponseFromReleasedRequest: return "Received response from released request"
            case .requestNotFound: return "Request not found"
            case .requestWasNotAddedToGroup: return "Request was not added to group"
            case .cantAddListener: return "Can't add listener"
            case .invalidRequest: return "Invalid request"
            case .modelClassNotFound(let request): return "Model class not found for request: \(String(describing: request))"
            case .modelClassNotRegistered(let model, let request): return "Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            }
        }
    }
    
    public typealias Context = ResponseParserContainerProtocol & LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseAdapterCreatorContainerProtocol
    
    public let uuid: UUID = UUID()
    private let context: Context

    private let grouppedListenerList = RequestGrouppedListenerList()
    private let grouppedRequestList = RequestGrouppedRequestList()
    private let adapterList = RequestAdaptersList()

    deinit {
        //
    }

    public required init(context: Context) {
        self.context = context
        super.init()
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
        //
        guard grouppedRequestList.addRequest(request, forGroupId: forGroupId) else {
            throw RequestManagerError.requestWasNotAddedToGroup
        }
        
        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)

        } else {
            context.logInspector?.logEvent(EventWarning(message: "request listener is nil"), sender: self)
        }

        try adapterList.addAdapter(jsonAdapterLinker, forRequest: request)

        try request.start(withArguments: withArguments)

        grouppedListenerList.didStartRequest(request, requestManager: self)
    }

    public func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws {
        let request = try createRequest(forRequestId: requestId)
        request.paradigm = paradigm

        let arguments = paradigm.buildRequestArguments()
        let jsonAdapterLinker = paradigm.jsonAdapterLinker
        let groupId = "Nested\(String(describing: paradigm.clazz))-\(arguments)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, jsonAdapterLinker: jsonAdapterLinker, listener: nil)
    }
    
    public func requestIds(forRequest request: RequestProtocol) throws -> [RequestIdType] {
        guard let modelClass = context.requestRegistrator?.modelClass(forRequest: request) else {
            throw RequestManagerError.modelClassNotFound(request)
        }

        guard let result = context.requestRegistrator?.requestIds(forClass: modelClass), result.count > 0 else {
            throw RequestManagerError.modelClassNotRegistered(modelClass, request)
        }
        return result
    }
    
    public func fetchRemote(paradigm: MappingParadigmProtocol) {
        guard let requestIDs = context.requestRegistrator?.requestIds(forClass: paradigm.clazz), requestIDs.count > 0 else {
            context.logInspector?.logEvent(EventError(WOTFetcherError.requestsNotParsed, details: nil), sender: self)
            return
        }
        requestIDs.forEach {
            do {
                try self.startRequest(by: $0, paradigm: paradigm)
            } catch {
                context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        }
    }
}

extension RequestManager {
    private func responseAdapters(for request: RequestProtocol) throws -> [DataAdapterProtocol]? {
        guard let grouppedLinker = try adapterList.adapterForRequest(request) else {
            throw RequestManagerError.adapterNotFound(request)
        }

        let requestIds = try requestIds(forRequest: request)

        return context.responseAdapterCreator?.responseAdapterInstances(byRequestIdTypes: requestIds, request: request, jsonAdapterLinker: grouppedLinker, requestManager: self)
    }
}

// MARK: - WOTRequestListenerProtocol

extension RequestManager: RequestListenerProtocol {
    
    public var md5: String? { uuid.MD5 }
    
    public func request(_ request: RequestProtocol, startedWith: HostConfigurationProtocol?) {
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
            let adapters = try responseAdapters(for: request)
            try context.responseParser?.parseResponse(data: data, forRequest: request, adapters: adapters, onParseComplete: {[weak self] request, error in
                guard let self = self else {
                    return
                }
                guard let request = request else {
                    self.context.logInspector?.logEvent(EventError(RequestManagerError.receivedResponseFromReleasedRequest, details: self), sender: self)
                    return
                }
                
                do {
                    try self.adapterList.removeAdapterForRequest(request)
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

private class RequestAdaptersList {
    
    private enum AdapterListError: Error {
        case adapterNotFound(RequestProtocol)
        case invalidRequest
        var debugDescription: String {
            switch self {
            case .adapterNotFound(let request): return "Adapter not found for request: \(String(describing: request))"
            case .invalidRequest: return "Invalid request"
            }
        }
    }
    private var adaptersList: [AnyHashable: JSONAdapterLinkerProtocol] = [:]
    func addAdapter(_ adapter: JSONAdapterLinkerProtocol, forRequest: RequestProtocol) throws {
        guard let requestMD5 = forRequest.MD5 else {
            throw AdapterListError.invalidRequest
        }
        adaptersList[requestMD5] = adapter
    }
    
    func adapterForRequest(_ request: RequestProtocol) throws -> JSONAdapterLinkerProtocol? {
        guard let requestMD5 = request.MD5 else {
            throw AdapterListError.invalidRequest
        }
        return adaptersList[requestMD5]
    }
    
    func removeAdapterForRequest(_ request: RequestProtocol) throws {
        guard let requestMD5 = request.MD5 else {
            throw AdapterListError.invalidRequest
        }
        adaptersList.removeValue(forKey: requestMD5)

    }
    
    func removeAdapter(_ linker: JSONAdapterLinkerProtocol) {
        var foundKey: AnyHashable?
        
        for key in adaptersList.keys {
            if adaptersList[key]?.MD5 == linker.MD5 {
                foundKey = key
                break
            }
        }
        if let key = foundKey {
            adaptersList.removeValue(forKey: key)
        }
    }
}

private class RequestGrouppedListenerList {
    
    private enum GrouppedListenersError: Error {
        case invalidRequest
    }
    
    private var grouppedListeners = [AnyHashable: [RequestManagerListenerProtocol]]()
    
    func didStartRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol) {
        guard let md5 = request.MD5 else {
            return
        }
        grouppedListeners[md5]?.forEach {
            $0.requestManager(requestManager, didStartRequest: request)
        }
    }
    
    func addListener(_ listener: RequestManagerListenerProtocol, forRequest: RequestProtocol) throws {
        guard let requestMD5 = forRequest.MD5 else {
            throw GrouppedListenersError.invalidRequest
        }
        if var listeners = grouppedListeners[requestMD5] {
            let filtered = listeners.filter { $0.md5 == listener.md5 }
            if filtered.count == 0 {
                listeners.append(listener)
                grouppedListeners[requestMD5] = listeners
            }
        } else {
            grouppedListeners[requestMD5] = [listener]
        }
    }
    
    func removeListener(_ listener: RequestManagerListenerProtocol) {
        for md5 in grouppedListeners.keys {
            if var listeners = grouppedListeners[md5] {
                listeners.removeAll { innerListener in
                    innerListener.md5 == listener.md5
                }
                grouppedListeners[md5] = listeners
                if let count = grouppedListeners[md5]?.count, count == 0 {
                    grouppedListeners[md5] = nil
                }
            }
        }
    }
    
    func didParseDataForRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, completionType: WOTRequestManagerCompletionResultType) throws {
        guard let md5 = request.MD5 else {
            throw GrouppedListenersError.invalidRequest
        }
        grouppedListeners[md5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, completionResultType: completionType)
        }
    }
}

private class RequestGrouppedRequestList {
    
    private var grouppedRequests: [RequestIdType: [RequestProtocol]] = [:]
    
    func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) -> Bool {
        var grouppedRequests: [RequestProtocol] = []
        if let available = self.grouppedRequests[groupId] {
            grouppedRequests.append(contentsOf: available)
        }
        let filtered = grouppedRequests.filter { $0.MD5 == request.MD5 }
        let result: Bool = (filtered.count == 0)
        if result {
            request.addGroup(groupId)
            grouppedRequests.append(request)
        }
        self.grouppedRequests[groupId] = grouppedRequests
        
        return result
    }
    
    func cancelRequests(groupId: RequestIdType, with error: Error?) {
        grouppedRequests[groupId]?.forEach { $0.cancel(with: error) }
    }
    
    func removeRequest(_ request: RequestProtocol) {
        for group in request.availableInGroups {
            if var grouppedRequests = self.grouppedRequests[group] {
                grouppedRequests.removeAll(where: { $0.MD5 == request.MD5 })
                self.grouppedRequests[group] = grouppedRequests
            }
        }
    }
}

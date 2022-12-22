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
        case requestWasNotAddedToGroup
        case requestNotFound
        case linkerNotFound(RequestProtocol)
        case receivedResponseFromReleasedRequest
        case adapterNotFound
        case cantAddListener
        case invalidRequest
        public var debugDescription: String {
            switch self {
            case .linkerNotFound(let request): return "Linker not found for [\(String(describing: request))]"
            case .receivedResponseFromReleasedRequest: return "Received response from released request"
            case .requestNotFound: return "Request not found"
            case .requestWasNotAddedToGroup: return "Request was not added to group"
            case .adapterNotFound: return "Adapter not found"
            case .cantAddListener: return "Can't add listener"
            case .invalidRequest: return "Invalid request"
            }
        }
    }
    
    public typealias Context = ResponseParserContainerProtocol & LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseAdapterCreatorContainerProtocol
    
    public let uuid: UUID = UUID()
    private let context: Context

    private let grouppedListeners = GrouppedListeners()
    private let grouppedRequests = GrouppedRequests()
    private var grouppedLinkers: [AnyHashable: JSONAdapterLinkerProtocol] = [:]

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
        grouppedRequests.cancelRequests(groupId: groupId, with: error)
    }

    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        grouppedListeners.removeListener(listener)
    }

    public func startRequest(_ request: RequestProtocol, withArguments: RequestArgumentsProtocol, forGroupId: RequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol, listener: RequestManagerListenerProtocol?) throws {
        //
        guard grouppedRequests.addRequest(request, forGroupId: forGroupId) else {
            throw RequestManagerError.requestWasNotAddedToGroup
        }
        
        guard let md5 = request.MD5 else {
            throw RequestManagerError.invalidRequest
        }

        request.addListener(self)

        if let listener = listener {
            try grouppedListeners.addListener(listener, forRequest: request)

        } else {
            context.logInspector?.logEvent(EventWarning(message: "request listener is nil"), sender: self)
        }

        grouppedLinkers[md5] = jsonAdapterLinker

        try request.start(withArguments: withArguments)

        grouppedListeners.didStartRequest(request, requestManager: self)
    }

    public func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws {
        let request = try createRequest(forRequestId: requestId)
        request.paradigm = paradigm

        let arguments = paradigm.buildRequestArguments()
        let jsonAdapterLinker = paradigm.jsonAdapterLinker
        let groupId = "Nested\(String(describing: paradigm.clazz))-\(arguments)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, jsonAdapterLinker: jsonAdapterLinker, listener: nil)
    }
}

extension RequestManager {
    private func responseAdapters(for request: RequestProtocol) throws -> [DataAdapterProtocol]? {
        guard let md5 = request.MD5 else {
            throw RequestManagerError.invalidRequest
        }
        guard let grouppedLinker = grouppedLinkers[md5] else {
            throw RequestManagerError.linkerNotFound(request)
        }

        let requestIds = self.requestIds(forRequest: request)

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
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: request), sender: self)
                }
                do {
                    try self.grouppedListeners.didParseDataForRequest(request, requestManager: self, completionType: .finished)
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
        grouppedRequests.removeRequest(request)
        request.removeListener(self)
    }
}

extension RequestManager {
    
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
    public func requestIds(forRequest request: RequestProtocol) -> [RequestIdType] {
        guard let modelClass = context.requestRegistrator?.modelClass(forRequest: request) else {
            let eventError = EventError(message: "model class not found for request\(type(of: request))")
            context.logInspector?.logEvent(eventError, sender: self)
            return []
        }

        guard let result = context.requestRegistrator?.requestIds(forClass: modelClass), result.count > 0 else {
            let eventError = EventError(message: "\(type(of: modelClass)) was not registered for request \(type(of: request))")
            context.logInspector?.logEvent(eventError, sender: self)
            return []
        }
        return result
    }
}

private class GrouppedListeners {
    
    private enum GrouppedListeners: Error {
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
            throw GrouppedListeners.invalidRequest
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
            throw GrouppedListeners.invalidRequest
        }
        grouppedListeners[md5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, completionResultType: completionType)
        }
    }
}

private class GrouppedRequests {
    
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

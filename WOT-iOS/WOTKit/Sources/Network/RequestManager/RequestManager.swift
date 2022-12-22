//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class RequestManager: NSObject, RequestManagerProtocol {
    
    private enum RequestManagerError: Error {
        case requestWasNotAddedToGroup
        case requestNotFound
        case linkerNotFound(RequestProtocol)
        case receivedResponseFromReleasedRequest
        case adapterNotFound
        public var debugDescription: String {
            switch self {
            case .linkerNotFound(let request): return "Linker not found for [\(String(describing: request))]"
            case .receivedResponseFromReleasedRequest: return "Received response from released request"
            case .requestNotFound: return "Request not found"
            case .requestWasNotAddedToGroup: return "Request was not added to group"
            case .adapterNotFound: return "Adapter not found"
            }
        }
    }
    
    public typealias Context = ResponseParserContainerProtocol & LogInspectorContainerProtocol & HostConfigurationContainerProtocol & RequestRegistratorContainerProtocol & ResponseAdapterCreatorContainerProtocol
    
    private let context: Context

    private var grouppedListeners = [AnyHashable: [RequestManagerListenerProtocol]]()
    private var grouppedRequests: [RequestIdType: [RequestProtocol]] = [:]
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

extension RequestManager {
    public func addListener(_ listener: RequestManagerListenerProtocol?, forRequest: RequestProtocol) {
        guard let listener = listener else { return }
        let uuid = forRequest.uuid.uuidString
        if var listeners = grouppedListeners[uuid] {
            let filtered = listeners.filter { (availableListener) -> Bool in availableListener.uuidHash == listener.uuidHash }
            if filtered.count == 0 {
                listeners.append(listener)
                grouppedListeners[uuid] = listeners
            }
        } else {
            grouppedListeners[uuid] = [listener]
        }
    }

    #warning("2b refactored")
    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        grouppedListeners.keys.forEach { uuid in
            if var listeners = grouppedListeners[uuid] {
                listeners.removeAll { innerListener in
                    innerListener.uuidHash == listener.uuidHash
                }
                grouppedListeners[uuid] = listeners
                if let count = grouppedListeners[uuid]?.count, count == 0 {
                    grouppedListeners[uuid] = nil
                }
            }
        }
    }

    #warning("2b refactored")
    private func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) -> Bool {
        var grouppedRequests: [RequestProtocol] = []
        if let available = self.grouppedRequests[groupId] {
            grouppedRequests.append(contentsOf: available)
        }
        let filtered = grouppedRequests.filter { (availableRequest) -> Bool in
            availableRequest.uuid.uuidString == request.uuid.uuidString
        }
        let result: Bool = (filtered.count == 0)
        if result {
            request.addListener(self)
            request.addGroup(groupId)
            grouppedRequests.append(request)
        }
        self.grouppedRequests[groupId] = grouppedRequests

        return result
    }

    public func startRequest(_ request: RequestProtocol, withArguments: RequestArgumentsProtocol, forGroupId: RequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol) throws {
        //
        guard addRequest(request, forGroupId: forGroupId) else {
            throw RequestManagerError.requestWasNotAddedToGroup
        }

        grouppedLinkers[request.uuid.uuidString] = jsonAdapterLinker

        try request.start(withArguments: withArguments)
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
    }

    public func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws {
        let request = try createRequest(forRequestId: requestId, paradigm: paradigm)

        let arguments = paradigm.buildRequestArguments()
        let jsonAdapterLinker = paradigm.jsonAdapterLinker
        let groupId = "Nested\(String(describing: paradigm.clazz))-\(arguments)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, jsonAdapterLinker: jsonAdapterLinker)
    }

    public func cancelRequests(groupId: RequestIdType, with error: Error?) {
        grouppedRequests[groupId]?.forEach { $0.cancel(with: error) }
    }

    public func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol {
        guard
            let Clazz = context.requestRegistrator?.requestClass(for: requestId) as? RequestProtocol.Type else {
            throw RequestManagerError.requestNotFound
        }
        return Clazz.init(context: context)
    }
}

extension RequestManager {
    private func createRequest(forRequestId requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws -> RequestProtocol {
        let request = try createRequest(forRequestId: requestId)
        request.paradigm = paradigm
        return request
    }
}

extension RequestManager {
    private func responseAdapters(for request: RequestProtocol) throws -> [DataAdapterProtocol]? {
        guard let jsonAdapterLinker = grouppedLinkers[request.uuid.uuidString] else {
            throw RequestManagerError.linkerNotFound(request)
        }

        let requestIds = self.requestIds(forRequest: request)

        return context.responseAdapterCreator?.responseAdapterInstances(byRequestIdTypes: requestIds, request: request, jsonAdapterLinker: jsonAdapterLinker, requestManager: self)
    }
}

// MARK: - Parser response
extension RequestManager {

    private func onParseComplete(_ request: RequestProtocol?, error: Error?) {
        guard let request = request else {
            context.logInspector?.logEvent(EventError(RequestManagerError.receivedResponseFromReleasedRequest, details: self), sender: self)
            return
        }
        if let error = error {
            context.logInspector?.logEvent(EventError(error, details: request), sender: self)
        }
        grouppedListeners[request.uuid.uuidString]?.forEach { listener in
            listener.requestManager(self, didParseDataForRequest: request, completionResultType: .finished)
        }
    }
}

// MARK: - WOTRequestListenerProtocol

extension RequestManager: RequestListenerProtocol {
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
            try context.responseParser?.parseResponse(data: data,
                                                      forRequest: request,
                                                      adapters: adapters,
                                                      onParseComplete: onParseComplete(_:error:))
        } catch {
            context.logInspector?.logEvent(EventError(error, details: String(describing: request)), sender: self)
        }
    }

    public func request(_ request: RequestProtocol, canceledWith error: Error?) {
        context.logInspector?.logEvent(EventWEBCancel(request), sender: self)
        removeRequest(request)
    }

    private func removeRequest(_ request: RequestProtocol) {
        request.availableInGroups.forEach { group in
            if var grouppedRequests = self.grouppedRequests[group] {
                grouppedRequests.removeAll(where: { $0.uuid.uuidString == request.uuid.uuidString })
                self.grouppedRequests[group] = grouppedRequests
            }
        }
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

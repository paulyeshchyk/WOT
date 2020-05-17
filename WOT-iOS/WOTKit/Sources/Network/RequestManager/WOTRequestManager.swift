//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTRequestManager: NSObject, WOTRequestManagerProtocol {
    @objc public var coordinator: WOTRequestCoordinatorProtocol
    @objc public var responseParser: WOTResponseParserProtocol
    @objc public var logInspector: LogInspectorProtocol
    @objc public var hostConfiguration: WOTHostConfigurationProtocol
    private var requestRegistrator: WOTRequestRegistratorProtocol

    fileprivate var grouppedListeners = [AnyHashable: [WOTRequestManagerListenerProtocol]]()
    fileprivate var grouppedRequests: [WOTRequestIdType: [WOTRequestProtocol]] = [:]
    fileprivate var grouppedLinkers: [AnyHashable: JSONAdapterLinkerProtocol] = [:]

    deinit {
        //
    }

    @objc
    public required init(requestCoordinator: WOTRequestCoordinatorProtocol, requestRegistrator: WOTRequestRegistratorProtocol, responseParser: WOTResponseParserProtocol, logInspector: LogInspectorProtocol, hostConfiguration hostConfig: WOTHostConfigurationProtocol) {
        self.coordinator = requestCoordinator
        self.hostConfiguration = hostConfig
        self.responseParser = responseParser
        self.logInspector = logInspector
        self.requestRegistrator = requestRegistrator
        super.init()
    }
}

// MARK: - WOTRequestManagerProtocol

extension WOTRequestManager {
    public func addListener(_ listener: WOTRequestManagerListenerProtocol?, forRequest: WOTRequestProtocol) {
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

    public func removeListener(_ listener: WOTRequestManagerListenerProtocol) {
        grouppedListeners.keys.forEach {
            if var listeners = grouppedListeners[$0] {
                listeners.removeAll { $0.uuidHash == listener.uuidHash }
                grouppedListeners[$0] = listeners
            }
        }
    }

    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: WOTRequestIdType) -> Bool {
        var grouppedRequests: [WOTRequestProtocol] = []
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

    public func startRequest(_ request: WOTRequestProtocol, withArguments: WOTRequestArgumentsProtocol, forGroupId: WOTRequestIdType, linker: JSONAdapterLinkerProtocol) throws {
        guard addRequest(request, forGroupId: forGroupId) else {
            throw WEBError.requestWasNotAddedToGroup
        }

        grouppedLinkers[request.uuid.uuidString] = linker

        try request.start(withArguments: withArguments)
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
    }

    public func startRequest(by requestId: WOTRequestIdType, paradigm: RequestParadigmProtocol) throws {
        let request = try createRequest(forRequestId: requestId, paradigm: paradigm)

        let arguments = paradigm.buildRequestArguments()
        let linker = paradigm.jsonAdapterLinker
        let groupId = "Nested\(String(describing: paradigm.clazz))-\(arguments)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, linker: linker)
    }

    public func cancelRequests(groupId: WOTRequestIdType, with error: Error?) {
        grouppedRequests[groupId]?.forEach { $0.cancel(with: error) }
    }
}

// MARK: - WOTRequestCoordinatorBridgeProtocol

extension WOTRequestManager {
    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        let result = try coordinator.createRequest(forRequestId: requestId)
        result.hostConfiguration = hostConfiguration
        return result
    }

    private func createRequest(forRequestId requestId: WOTRequestIdType, paradigm: RequestParadigmProtocol) throws -> WOTRequestProtocol {
        let request = try createRequest(forRequestId: requestId)
        request.paradigm = paradigm
        return request
    }
}

// MARK: - WOTRequestManagerProtocol

extension WOTRequestManager: WOTRequestListenerProtocol {
    public func request(_ request: WOTRequestProtocol, startedWith: WOTHostConfigurationProtocol, args: WOTRequestArgumentsProtocol) {
        logInspector.logEvent(EventWEBStart(request), sender: self)
    }

    public func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            self.logInspector.logEvent(EventWEBEnd(request), sender: self)
            removeRequest(request)
        }

        if let error = error {
            logInspector.logEvent(EventError(error, details: request), sender: self)
            return
        }

        guard let adapterLinker = grouppedLinkers[request.uuid.uuidString] else {
            logInspector.logEvent(EventError(WOTRequestManagerError.linkerNotFound(request), details: self), sender: self)
            return
        }

        let requestIds = coordinator.requestIds(forRequest: request)

        var adapters: [DataAdapterProtocol] = .init()
        requestIds.forEach { requestIdType in
            do {
                let adapter = try requestRegistrator.responseAdapterInstance(for: requestIdType, request: request, linker: adapterLinker)
                adapters.append(adapter)
            } catch {
                logInspector.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        if adapters.count == 0 {
            onRequestComplete(request, self, error: nil)//no adapters found
            return
        }

        do {
            try responseParser.parseResponse(data: data,
                                             forRequest: request,
                                             adapters: adapters,
                                             linker: adapterLinker,
                                             onRequestComplete: onRequestComplete(_:_:error:))
        } catch {
            logInspector.logEvent(EventError(error, details: String(describing: request)), sender: self)
        }
    }

    public func request(_ request: WOTRequestProtocol, canceledWith error: Error?) {
        logInspector.logEvent(EventWEBCancel(request))
        removeRequest(request)
    }

    private func onRequestComplete(_ request: WOTRequestProtocol?, _ sender: Any?, error: Error?) {
        guard let request = request else {
            logInspector.logEvent(EventError(WOTRequestManagerError.receivedResponseFromReleasedRequest, details: self), sender: self)
            return
        }
        if let error = error {
            logInspector.logEvent(EventError(error, details: request), sender: self)
        }
        grouppedListeners[request.uuid.uuidString]?.forEach { listener in
            listener.requestManager(self, didParseDataForRequest: request, completionResultType: .finished)
        }
    }

    private func removeRequest(_ request: WOTRequestProtocol) {
        request.availableInGroups.forEach { group in
            if var grouppedRequests = self.grouppedRequests[group] {
                grouppedRequests.removeAll(where: { $0.uuid.uuidString == request.uuid.uuidString })
                self.grouppedRequests[group] = grouppedRequests
            }
        }
        request.removeListener(self)
    }
}

// MARK: - Extension RequestParadigmProtocol

extension RequestParadigmProtocol {
    public func buildRequestArguments() -> WOTRequestArguments {
        let keyPaths = clazz.classKeypaths().compactMap {
            self.addPreffix(to: $0)
        }

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        primaryKeys.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }
        return arguments
    }
}

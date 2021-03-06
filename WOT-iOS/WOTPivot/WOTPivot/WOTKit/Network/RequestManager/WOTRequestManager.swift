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
    deinit {
        //
    }

    @objc
    public required init(requestCoordinator: WOTRequestCoordinatorProtocol, hostConfiguration hostConfig: WOTHostConfigurationProtocol) {
        coordinator = requestCoordinator
        hostConfiguration = hostConfig
        super.init()
    }

    // MARK: WOTRequestManagerProtocol-

    @objc public var appManager: WOTAppManagerProtocol?
    @objc public var coordinator: WOTRequestCoordinatorProtocol
    @objc public var hostConfiguration: WOTHostConfigurationProtocol

    fileprivate var grouppedListeners = [AnyHashable: [WOTRequestManagerListenerProtocol]]()
    fileprivate var grouppedRequests: [WOTRequestIdType: [WOTRequestProtocol]] = [:]
    fileprivate var grouppedAdapterInstanceHelpers: [AnyHashable: JSONAdapterInstanceHelper] = [:]

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

    public func startRequest(_ request: WOTRequestProtocol, withArguments: WOTRequestArgumentsProtocol, forGroupId: WOTRequestIdType, instanceHelper: JSONAdapterInstanceHelper?) throws {
        guard addRequest(request, forGroupId: forGroupId) else {
            throw WEBError.requestWasNotAddedToGroup
        }

        grouppedAdapterInstanceHelpers[request.uuid.uuidString] = instanceHelper

        try request.start(withArguments: withArguments)
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
    }

    public func startRequest(by requestId: WOTRequestIdType, withPredicate: WOTPredicate, instanceHelper: JSONAdapterInstanceHelper?) throws {
        let request = try createRequest(forRequestId: requestId, withPredicate: withPredicate)

        let arguments = withPredicate.buildRequestArguments()
        let groupId = "Nested\(String(describing: withPredicate.clazz))-\(withPredicate)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, instanceHelper: instanceHelper)
    }

    public func cancelRequests(groupId: WOTRequestIdType, with error: Error?) {
        grouppedRequests[groupId]?.forEach { $0.cancel(with: error) }
    }

    // MARK: WOTRequestCoordinatorBridgeProtocol-

    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        let result = try coordinator.createRequest(forRequestId: requestId)
        result.hostConfiguration = hostConfiguration
        return result
    }

    private func createRequest(forRequestId requestId: WOTRequestIdType, withPredicate: WOTPredicate) throws -> WOTRequestProtocol {
        let request = try createRequest(forRequestId: requestId)
        request.predicate = withPredicate
        return request
    }
}

extension WOTRequestManager: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

extension WOTRequestManager: WOTRequestListenerProtocol {
    public func request(_ request: WOTRequestProtocol, startedWith: WOTHostConfigurationProtocol, args: WOTRequestArgumentsProtocol) {
        appManager?.logInspector?.logEvent(EventWEBStart(request.description), sender: self)
    }

    public func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            appManager?.logInspector?.logEvent(EventWEBEnd(request.description), sender: self)
            removeRequest(request)
        }

        if let error = error {
            appManager?.logInspector?.logEvent(EventError(error, details: request), sender: self)
            return
        }

        guard let dataparser = appManager?.responseCoordinator else {
            appManager?.logInspector?.logEvent(EventError(message: "dataparser not found"), sender: self)
            return
        }

        let adapterInstanceHelper = grouppedAdapterInstanceHelpers[request.uuid.uuidString]
        do {
            try dataparser.parseResponse(data: data,
                                         forRequest: request,
                                         instanceHelper: adapterInstanceHelper,
                                         onComplete: onRequestComplete(_:_:error:))
        } catch {
            appManager?.logInspector?.logEvent(EventError(error, details: request), sender: self)
        }
    }

    public func request(_ request: WOTRequestProtocol, canceledWith error: Error?) {
        appManager?.logInspector?.logEvent(EventWEBCancel(request.description))
        removeRequest(request)
    }

    private func onRequestComplete(_ request: WOTRequestProtocol?, _ sender: Any?, error: Error?) {
        guard let request = request else {
            print("Unknown request finished")
            return
        }
        grouppedListeners[request.uuid.uuidString]?.forEach { listener in
            listener.requestManager(self, didParseDataForRequest: request, completionResultType: .finished, error: error)
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

extension WOTRequestManager: Describable {
    override public var description: String {
        return "WOTRequestManager"
    }
}

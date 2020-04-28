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
    @objc public var hostConfiguration: WOTHostConfigurationProtocol
    @objc public var appManager: WOTAppManagerProtocol?

    deinit {
        //
    }

    @objc
    required public init(requestCoordinator: WOTRequestCoordinatorProtocol, hostConfiguration hostConfig: WOTHostConfigurationProtocol) {
        coordinator = requestCoordinator
        hostConfiguration = hostConfig
        super.init()
    }

    fileprivate var grouppedListeners = [AnyHashable: [WOTRequestManagerListenerProtocol]]()
    fileprivate var grouppedRequests: [String: [WOTRequestProtocol]] = [:]
    fileprivate var grouppedObjectDidParse: [AnyHashable: NSManagedObjectErrorCompletion] = [:]

    //
    @objc
    public func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol? {
        let result = coordinator.createRequest(forRequestId: requestId)
        result?.hostConfiguration = hostConfiguration
        return result
    }

    private func createRequest(forRequestId requestId: WOTRequestIdType, jsonLink: WOTPredicate) -> WOTRequestProtocol? {
        guard jsonLink.clazz.conforms(to: KeypathProtocol.self) else {
            return nil
        }
        let request = createRequest(forRequestId: requestId)
        request?.jsonLink = jsonLink
        return request
    }

    @objc
    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String) -> Bool {
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

    @objc
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

    @objc
    public func removeListener(_ listener: WOTRequestManagerListenerProtocol) {
        grouppedListeners.keys.forEach {
            if var listeners = grouppedListeners[$0] {
                listeners.removeAll { $0.uuidHash == listener.uuidHash }
                grouppedListeners[$0] = listeners
            }
        }
    }

    public func startRequest(_ request: WOTRequestProtocol, withArguments: WOTRequestArgumentsProtocol, forGroupId: String, onObjectDidFetch: NSManagedObjectErrorCompletion?) throws {
        guard addRequest(request, forGroupId: forGroupId) else {
            throw WEBError.requestWasNotAddedToGroup
        }

        self.grouppedObjectDidParse[request.uuid.uuidString] = onObjectDidFetch

        try request.start(withArguments: withArguments)
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
    }

    public func startRequest(by requestId: WOTRequestIdType, withPredicate: WOTPredicate, onObjectDidFetch: NSManagedObjectErrorCompletion?) throws {
        guard let request = self.createRequest(forRequestId: requestId, jsonLink: withPredicate) else {
            throw WEBError.requestIsNotCreated
        }

        let arguments = withPredicate.buildRequestArguments()
        let groupId = "Nested\(String(describing: withPredicate.clazz))-\(withPredicate)"
        try startRequest(request, withArguments: arguments, forGroupId: groupId, onObjectDidFetch: onObjectDidFetch)
    }

    @objc
    public func cancelRequests(groupId: String) {
        grouppedRequests[groupId]?.forEach { $0.cancel() }
    }
}

extension WOTRequestManager: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

extension WOTRequestManager: WOTRequestListenerProtocol {
    public func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        if let error = error {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
        }

        let onObjectDidParse = self.grouppedObjectDidParse[request.uuid.uuidString]
        coordinator.request(request, processBinary: data, onObjectDidParse: onObjectDidParse, onRequestComplete: self.onRequestComplete(_:_:error:))

        appManager?.logInspector?.log(WEBFinishLog(request.description), sender: self)
        self.removeRequest(request)
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

    private func jsonLinksCallback(_ jsonLinks: [WOTPredicate]?) {}

    public func requestHasCanceled(_ request: WOTRequestProtocol) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        appManager?.logInspector?.log(WEBCancelLog(request.description))
        removeRequest(request)
    }

    public func requestHasStarted(_ request: WOTRequestProtocol) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        appManager?.logInspector?.log(WEBStartLog(request.description), sender: self)
    }

    public func removeRequest(_ request: WOTRequestProtocol) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        request.availableInGroups.forEach { group in
            if var grouppedRequests = self.grouppedRequests[group] {
                grouppedRequests.removeAll(where: { $0.uuid.uuidString == request.uuid.uuidString })
                self.grouppedRequests[group] = grouppedRequests
            }
        }
        self.grouppedObjectDidParse[request.uuid.uuidString] = nil
        request.removeListener(self)
    }
}

extension WOTRequestManager: Describable {
    public override var description: String {
        return "WOTRequestManager"
    }
}

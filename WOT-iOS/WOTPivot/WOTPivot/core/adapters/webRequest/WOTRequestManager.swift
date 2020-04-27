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
    fileprivate var externalCallbacks: [AnyHashable: NSManagedObjectOptionalCallback] = [:]

    private func request(_ request: WOTRequestProtocol, addOnCreateNSManagedObject callback: NSManagedObjectOptionalCallback?) {
        externalCallbacks[request.uuid.uuidString] = callback
    }

    @objc
    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String, jsonLink: WOTJSONPredicate?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?) -> Bool {
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
        self.request(request, addOnCreateNSManagedObject: onCreateNSManagedObject)

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

    @objc
    public func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String, jsonLink: WOTJSONPredicate?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?) {
        guard addRequest(request, forGroupId: forGroupId, jsonLink: jsonLink, onCreateNSManagedObject: onCreateNSManagedObject) else {
            return
        }

        request.hostConfiguration = hostConfiguration
        guard request.start(arguments) == true else {
            return
        }
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
        return
    }

    @objc
    public func cancelRequests(groupId: String) {
        grouppedRequests[groupId]?.forEach { $0.cancel() }
    }

    public func queue(requestId: WOTRequestIdType, jsonLink: WOTJSONPredicate, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, listener: WOTRequestManagerListenerProtocol?) {
        guard jsonLink.clazz.conforms(to: KeypathProtocol.self) else {
            return
        }
        guard let request = coordinator.createRequest(forRequestId: requestId) else {
            return
        }

        let keyPaths = jsonLink.clazz.classKeypaths().compactMap {
            jsonLink.addPreffix(to: $0)
        }

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        jsonLink.primaryKeys.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }

        request.hostConfiguration = hostConfiguration
        request.jsonLink = jsonLink

        self.addListener(listener, forRequest: request)

        let groupId = "Nested\(String(describing: jsonLink.clazz))-\(jsonLink)"

        start(request, with: arguments, forGroupId: groupId, jsonLink: jsonLink, onCreateNSManagedObject: onCreateNSManagedObject)
    }
}

extension WOTRequestManager: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

extension WOTRequestManager: WOTRequestListenerProtocol {
    public func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol? {
        coordinator.createRequest(forRequestId: requestId)
    }

    public func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }
        if let error = error {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
        }

        let onCreateNSManagedObject = self.externalCallbacks[request.uuid.uuidString]
        coordinator.request(request, processBinary: data, onCreateNSManagedObject: onCreateNSManagedObject, onFinish: { [weak self] sender, error in
            if let error = error {
                self?.appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            }
            self?.request(request, didCompleteParsing: .finished)
        })

        appManager?.logInspector?.log(WEBFinishLog(request.description), sender: self)
        self.removeRequest(request)
    }

    private func request(_ request: WOTRequestProtocol, didCompleteParsing complete: WOTRequestManagerCompletionResultType ) {
        grouppedListeners[request.uuid.uuidString]?.forEach { listener in
            listener.requestManager(self, didParseDataForRequest: request, completionResultType: complete)
        }
    }

    private func jsonLinksCallback(_ jsonLinks: [WOTJSONPredicate]?) {}

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
        externalCallbacks[request.uuid.uuidString] = nil
        request.removeListener(self)
    }
}

extension WOTRequestManager: Describable {
    public override var description: String {
        return "WOTRequestManager"
    }
}

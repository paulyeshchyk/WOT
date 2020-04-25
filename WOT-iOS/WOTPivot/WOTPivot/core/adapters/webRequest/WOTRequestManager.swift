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
    fileprivate var subordinateLinks: [AnyHashable: [WOTJSONLink]] = [:]
    fileprivate var externalCallbacks: [AnyHashable: NSManagedObjectCallback] = [:]

    private func request(_ request: WOTRequestProtocol, addExternalCallback callback: NSManagedObjectCallback?) {
        #warning("try to use array of callbacks")
        externalCallbacks[request.uuid.uuidString] = callback
    }

    private func request(_ request: WOTRequestProtocol, addSubordinateLink link: WOTJSONLink?) {
        guard let link = link else { return }
        if var linksForRequest = subordinateLinks[request.uuid.uuidString] {
            if linksForRequest.firstIndex(of: link) == nil {
                linksForRequest.append(link)
                subordinateLinks[request.uuid.uuidString] = linksForRequest
            }
        } else {
            subordinateLinks[request.uuid.uuidString] = [link]
        }
    }

    private func request(_ request: WOTRequestProtocol, removeSubordinateLink link: WOTJSONLink) {
        if var linksForRequest = subordinateLinks[request.uuid.uuidString] {
            if let index = linksForRequest.firstIndex(of: link) {
                linksForRequest.remove(at: index)
            }
        }
    }

    @objc
    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String, jsonLink: WOTJSONLink?, externalCallback: NSManagedObjectCallback?) -> Bool {
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
        self.request(request, addSubordinateLink: jsonLink)
        self.request(request, addExternalCallback: externalCallback)

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
    @discardableResult
    public func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String, jsonLink: WOTJSONLink?, externalCallback: NSManagedObjectCallback?) -> Bool {
        guard addRequest(request, forGroupId: forGroupId, jsonLink: jsonLink, externalCallback: externalCallback) else { return false }

        request.hostConfiguration = hostConfiguration
        guard request.start(arguments) == true else { return false }
        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didStartRequest: request)
        }
        return true
    }

    @objc
    public func cancelRequests(groupId: String) {
        grouppedRequests[groupId]?.forEach { $0.cancel() }
    }

    @discardableResult
    public func queue(parentRequest: WOTRequestProtocol?, requestId: WOTRequestIdType, jsonLink: WOTJSONLink, externalCallback: NSManagedObjectCallback?, listener: WOTRequestManagerListenerProtocol?) -> Bool {
        guard let clazz = jsonLink.clazz as? NSObject.Type, clazz.conforms(to: KeypathProtocol.self) else { return false }
        guard let obj = clazz.init() as? KeypathProtocol else { return false }
        guard let request = coordinator.createRequest(forRequestId: requestId) else { return false }

        let keyPaths = type(of: obj).classKeypaths().compactMap {
            jsonLink.addPreffix(to: $0)
        }

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        jsonLink.primaryKeys?.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }

        request.hostConfiguration = hostConfiguration
        request.parentRequest = parentRequest

        self.addListener(listener, forRequest: request)

        let groupId = "Nested\(String(describing: clazz))-\(jsonLink)"

        return start(request, with: arguments, forGroupId: groupId, jsonLink: jsonLink, externalCallback: externalCallback)
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

        let subordinateLinks = self.subordinateLinks[request.uuid.uuidString]
        let externalCallback = self.externalCallbacks[request.uuid.uuidString]
        coordinator.request(request, processBinary: data, jsonLinkAdapter: appManager?.jsonLinksAdapter, subordinateLinks: subordinateLinks, externalCallback: externalCallback, onFinish: { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
                }
                self?.request(request, didCompleteParsing: .finished)
            }
        })

        appManager?.logInspector?.log(WEBFinishLog(request.description), sender: self)
        self.removeRequest(request)
    }

    private func request(_ request: WOTRequestProtocol, didCompleteParsing complete: WOTRequestManagerCompletionResultType ) {
        guard Thread.current.isMainThread else {
            fatalError("Current thread is not main")
        }

        grouppedListeners[request.uuid.uuidString]?.forEach {
            $0.requestManager(self, didParseDataForRequest: request, completionResultType: complete)
        }
    }

    private func jsonLinksCallback(_ jsonLinks: [WOTJSONLink]?) {}

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
        subordinateLinks[request.uuid.uuidString] = nil
        request.removeListener(self)
    }
}

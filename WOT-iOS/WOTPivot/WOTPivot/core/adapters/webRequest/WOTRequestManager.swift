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
    public var listeners = [WOTRequestManagerListenerProtocol]()

    @objc
    required public init(requestCoordinator: WOTRequestCoordinatorProtocol, hostConfiguration: WOTHostConfigurationProtocol) {
        coordinator = requestCoordinator
        hostConfig = hostConfiguration

        super.init()
    }

    fileprivate var grouppedRequests: [String: [WOTRequestProtocol]] = [:]

    @objc
    private var coordinator: WOTRequestCoordinatorProtocol

    @objc
    private var hostConfig: WOTHostConfigurationProtocol

    @objc
    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String, jsonLink: WOTJSONLink?) -> Bool {
        var grouppedRequests: [WOTRequestProtocol] = []
        if let available = self.grouppedRequests[groupId] {
            grouppedRequests.append(contentsOf: available)
        }
        let filtered = grouppedRequests.filter { (availableRequest) -> Bool in
            availableRequest.hash == request.hash
        }
        let result: Bool = (filtered.count == 0)
        if result {
            request.addListener(self)
            request.addGroup(groupId)
            grouppedRequests.append(request)
        }
        self.grouppedRequests[groupId] = grouppedRequests
        print("\nadded request:[\(groupId)]")
        return result
    }

    @objc
    public func addListener(_ listener: WOTRequestManagerListenerProtocol, forRequest: WOTRequestProtocol) {
        listeners.append(listener)
    }

    @objc
    public func removeListener(_ listener: WOTRequestManagerListenerProtocol) {
        listeners.removeAll { $0.hashData == listener.hashData }
    }

    @objc
    @discardableResult
    public func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String, jsonLink: WOTJSONLink?) -> Bool {
        guard addRequest(request, forGroupId: forGroupId, jsonLink: jsonLink) else { return false }

        request.hostConfiguration = hostConfig
        let result = request.start(arguments)
        if result {
            listeners.forEach {
                $0.requestManager(self, didStartRequest: request)
            }
        }
        return result
    }

    @objc
    public func cancelRequests(groupId: String) {
        grouppedRequests[groupId]?.forEach { $0.cancel() }
    }

    fileprivate func request(_ parentRequest: WOTRequestProtocol?, queueJsonLinks jsonLinks: ([WOTJSONLink?])?) {
        guard let jsonLinks = jsonLinks, jsonLinks.count != 0 else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            jsonLinks.compactMap { $0 }.forEach { jsonLink in
                if let requestIDs = self.requestCoordinator.requestIds(forClass: jsonLink.clazz) {
                    requestIDs.forEach {
                        self.queue(parentRequest: parentRequest, requestId: $0, jsonLink: jsonLink)
                    }
                } else {
                    print("requests not parsed")
                }
            }
        }
    }

    @discardableResult
    private func queue(parentRequest: WOTRequestProtocol?, requestId: WOTRequestIdType, jsonLink: WOTJSONLink) -> Bool {
        guard let clazz = jsonLink.clazz as? NSObject.Type, clazz.conforms(to: KeypathProtocol.self) else { return false }
        guard let obj = clazz.init() as? KeypathProtocol else { return false }
        guard let request = requestCoordinator.createRequest(forRequestId: requestId) else { return false }

        let keyPaths = obj.instanceKeypaths().compactMap {
            jsonLink.addPreffix(to: $0)
        }

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        jsonLink.primaryKeys?.forEach {
            arguments.setValues([$0.value], forKey: $0.name)
        }

        request.hostConfiguration = hostConfiguration
        request.parentRequest = parentRequest

        let groupId = "Nested\(String(describing: clazz))-\(jsonLink)"

        return start(request, with: arguments, forGroupId: groupId, jsonLink: jsonLink)
    }
}

extension WOTRequestManager: JSONLinksAdapterProtocol {
    public func request(_ request: WOTRequestProtocol, adoptJsonLinks jsonLinks: [WOTJSONLink]?) {
        let theRequest = request.parentRequest ?? request
        let links = jsonLinks?.compactMap { $0 } ?? []
        let completed = (links.count == 0)
        self.request(theRequest, queueJsonLinks: jsonLinks)
        self.request(theRequest, didCompleteParsing: completed)
    }
}

extension WOTRequestManager: WOTRequestListenerProtocol {
    public var requestCoordinator: WOTRequestCoordinatorProtocol {
        get { return coordinator }
        set { coordinator = newValue }
    }

    public var hostConfiguration: WOTHostConfigurationProtocol {
        get { return hostConfig }
        set { hostConfig = newValue }
    }

    public func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?) {
//        fatalError("get applied json link and run completion")
        //
        print("\nfinished load data for request:\n\(request.description)")
        requestCoordinator.request(request, processBinary: data, jsonLinkAdapter: self)

        self.removeRequest(request)
    }

    private func request(_ request: WOTRequestProtocol, didCompleteParsing complete: Bool ) {
        listeners.forEach {
            $0.requestManager(self, didParseDataForRequest: request, finished: complete)
        }
    }

    private func jsonLinksCallback(_ jsonLinks: [WOTJSONLink]?) {}

    public func requestHasCanceled(_ request: WOTRequestProtocol) {
        print("\ncenceled request:\n\(request.description)")
        removeRequest(request)
    }

    public func requestHasStarted(_ request: WOTRequestProtocol) {
        print("\nstarted request:\n\(request.description)")
    }

    public func removeRequest(_ request: WOTRequestProtocol) {
        request.availableInGroups.forEach { group in
            if var grouppedRequests = self.grouppedRequests[group] {
                grouppedRequests.removeAll(where: { $0.hash == request.hash })
                self.grouppedRequests[group] = grouppedRequests
            }
        }
        request.removeListener(self)
    }
}

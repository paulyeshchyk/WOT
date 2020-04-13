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
    private func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String) -> Bool {
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
    public func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String) -> Bool {
        guard addRequest(request, forGroupId: forGroupId) else { return false }

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

    fileprivate func queue(parentRequest: WOTRequestProtocol?, jsonLinks: ([WOTJSONLink?])?) {
        jsonLinks?.compactMap { $0 }.forEach { (linkedObjectRequest) in
            if let requestIDs = requestCoordinator.requestIds(forClass: linkedObjectRequest.clazz) {
                requestIDs.forEach({ (requestId) in
                    queue(parentRequest: parentRequest, requestId: requestId, jsonLink: linkedObjectRequest)
                })
            } else {
                print("requests not parsed")
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

        let groupId = "Nested\(String(describing: clazz))-\(String(describing: jsonLink.primaryKeys))"

        return start(request, with: arguments, forGroupId: groupId)
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
        defer {
            self.removeRequest(request)
        }

        print("\nended request:\n\(request.description)")

        guard let clazz = type(of: request) as? NSObject.Type else { return }
        guard let instance = clazz.init() as? WOTModelServiceProtocol else { return }
        guard let modelClass = instance.instanceModelClass() else { return }

        let requestIds = requestCoordinator.requestIds(forClass: modelClass)
        requestIds?.forEach({ requestId in
            requestCoordinator.processBinary(data, forRequestId: requestId, error: error, jsonLinksCallback: { [weak self] jsonLinks in
                guard let self = self else { return }
                guard let links = jsonLinks else {
//                    print("no links found for: \(request.description)")
                    return
                }
                DispatchQueue.main.async {
                    self.listeners.forEach {
                        let finished = (links.count == 0)
                        let theRequest = request.parentRequest ?? request
                        if finished {
                            $0.requestManager(self, didParseDataForRequest: theRequest, finished: finished)
                        }
                    }
                    self.queue(parentRequest: request.parentRequest ?? request, jsonLinks: jsonLinks)
                }
            })
        })
    }

    private func jsonLinksCallback(_ jsonLinks: [WOTJSONLink]?) {}

    public func requestHasCanceled(_ request: WOTRequestProtocol) {
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

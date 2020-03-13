//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc(WOTRequestExecutorSwift)
public class WOTRequestManager: NSObject, WOTRequestManagerProtocol {
    
    @objc
    required public init(requestCoordinator: WOTRequestCoordinatorProtocol, hostConfiguration: WOTHostConfigurationProtocol) {
        coordinator = requestCoordinator
        hostConfig = hostConfiguration

        super.init()
    }
    
    @objc
    public static let pendingRequestNotificationName: String = "WOTRequestExecutorPendingRequestNotificationName"
    
    fileprivate var grouppedRequests: [String: [WOTRequestProtocol]] = [:]
    
    @objc
    private var coordinator: WOTRequestCoordinatorProtocol
    
    @objc
    private var hostConfig: WOTHostConfigurationProtocol

    @objc
    public var pendingRequestsCount: Int = 0

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
        return result
    }
    
    @objc
    @discardableResult
    public func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String) -> Bool {

        if (!addRequest(request, forGroupId: forGroupId)) { return false }
        
        return request.start(arguments)
    }

    @objc
    public func cancelRequests(groupId: String) {

        grouppedRequests[groupId]?.forEach { request in
            request.cancel()
        }
    }
    
    fileprivate func startRequests(from: [JSONLinkedObjectRequest?]) {
        from.compactMap { $0 }.forEach { (linkedObjectRequest) in
            let requestIDs = requestCoordinator.requestIds(forClass: linkedObjectRequest.clazz)
            requestIDs?.forEach({ (requestId) in
                queueRequest(for: requestId, nestedRequest: linkedObjectRequest)
            })
        }
    }
    
    
    @discardableResult
    private func queueRequest(for requestId: WOTRequestIdType, nestedRequest: JSONLinkedObjectRequest) -> Bool {

        guard let clazz = nestedRequest.clazz as? NSObject.Type, clazz.conforms(to: KeypathProtocol.self) else { return false }
        guard let obj = clazz.init() as? KeypathProtocol else { return false }
        guard let request = requestCoordinator.createRequest(forRequestId: requestId) else { return false }

        let keyPaths = obj.instanceKeypaths()

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        if let ident = nestedRequest.identifier, let ident_fieldName = nestedRequest.identifier_fieldname {
            arguments.setValues([ident], forKey: ident_fieldName)
        }

        request.hostConfiguration = hostConfiguration

        let groupId = "Nested\(String(describing: clazz))-\(nestedRequest.identifier ?? "")"

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

    public func request(_ request: AnyObject, finishedLoadData data: Data?, error: Error?) {
        defer {
            pendingRequestsCount -= 1
            #warning ("force cast")
            self.removeRequest(request as! WOTRequestProtocol)
        }
        
        guard let clazz = type(of: request) as? NSObject.Type else { return }
        guard let instance = clazz.init() as? WOTModelServiceProtocol else { return }
        guard let modelClass = instance.instanceModelClass() else { return }

        let requestIds = requestCoordinator.requestIds(forClass: modelClass)
        requestIds?.forEach({ requestId in
            requestCoordinator.requestId(requestId, processBinary: data, error: error, completion: { [weak self] nextPortionOfRequests in
                
                self?.startRequests(from: nextPortionOfRequests ?? [])
            })
        })
        
        
    }
    
    public func requestHasCanceled(_ request: WOTRequestProtocol) {
        pendingRequestsCount -= 1
        removeRequest(request)
    }
    
    public func requestHasStarted(_ request: WOTRequestProtocol) {
        pendingRequestsCount += 1
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

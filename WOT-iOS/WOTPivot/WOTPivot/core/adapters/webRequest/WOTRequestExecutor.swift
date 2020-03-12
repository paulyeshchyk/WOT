//
//  WOTRequestExecutor.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc(WOTRequestExecutorSwift)
public class WOTRequestExecutorSwift: NSObject, WOTRequestManagerProtocol {
    
    @objc
    required public  init(requestReception: WOTRequestReceptionProtocol) {
        reception = requestReception
        super.init()
    }
    
    @objc
    public static let pendingRequestNotificationName: String = "WOTRequestExecutorPendingRequestNotificationName"
    
    fileprivate var grouppedRequests: [String: [WOTRequestProtocol]] = [:]
    
    @objc
    public var reception: WOTRequestReceptionProtocol

// WOTRequestExecutorSwift

    @objc
    public var pendingRequestsCount: Int = 0

    @objc
    public func addRequest(_ request: WOTRequestProtocol, forGroupId groupId: String) -> Bool {
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
    public func cancelRequests(groupId: String) {
        guard let requests = self.grouppedRequests[groupId], requests.count > 0 else {
            return
        }
        requests.forEach { request in
            request.cancel()
        }
    }
}


extension WOTRequestExecutorSwift: WOTRequestListenerProtocol {
    
    public var requestReception: WOTRequestReceptionProtocol {
        get { return reception }
        set { reception = newValue }
    }

    public func request(_ request: AnyObject, finishedLoadData data: Data?, error: Error?, invokedBy: WOTNestedRequestsEvaluatorProtocol) {
        if let clazz = type(of: request) as? NSObject.Type {
            if let instance = clazz.init() as? WOTModelServiceProtocol {
                if let modelClass = instance.instanceModelClass() {
                    let requestIds = requestReception.requestIds(forClass: modelClass)
                    requestIds?.forEach({ requestId in
                        requestReception.requestId(requestId, processBinary: data, error: error, invokedBy: invokedBy)
                    })
                }
            }
        }
        pendingRequestsCount -= 1
        #warning ("force cast")
        self.removeRequest(request as! WOTRequestProtocol)
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

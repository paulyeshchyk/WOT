//
//  WOTRequestExecutor.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc(WOTRequestExecutorSwift)
public class WOTRequestExecutorSwift: NSObject {
    
    @objc
    public static let sharedInstance = WOTRequestExecutorSwift()
    
    @objc
    public static let pendingRequestNotificationName: String = "WOTRequestExecutorPendingRequestNotificationName"
    
    @objc
    public var pendingRequestsCount: Int = 0
    fileprivate var grouppedRequests: [String: [WOTRequestProtocol]] = [:]
 
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
    
    public func request(_ request: AnyObject, finishedLoadData data: Data?, error: Error?) {
        if let clazz = type(of: request) as? NSObject.Type {
            if let instance = clazz.init() as? WOTModelServiceProtocol {
                if let modelClass = instance.instanceModelClass() {
                    let requestIds = WOTRequestReception.sharedInstance.requestIds(forClass: modelClass)
                    requestIds?.forEach({ requestId in
                        WOTRequestReception.sharedInstance.requestId(requestId, processBinary: data, error: error)
                    })
                }
            }
        }
        pendingRequestsCount -= 1
        //TODO: force cast
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

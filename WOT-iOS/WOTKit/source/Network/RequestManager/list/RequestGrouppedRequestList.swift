//
//  RequestGrouppedRequestList.swift
//  WOTKit
//
//  Created by Paul on 16.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - RequestGrouppedRequestList

class RequestGrouppedRequestList {

    typealias Context = LogInspectorContainerProtocol

    typealias CancelCompletion = (RequestProtocol, RequestCancelReasonProtocol) -> Void

    private var list: [RequestIdType: [RequestProtocol]] = [:]

    private let appContext: Context

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Internal

    func addRequest(_ request: RequestProtocol, forGroupId groupId: RequestIdType) throws {
        if list.keys.isEmpty {
            appContext.logInspector?.log(.flow(name: "group", message: "Start: <\(String(describing: request))>"), sender: self)
        }

        var requestsForID: [RequestProtocol] = []
        if let available = list[groupId] {
            requestsForID.append(contentsOf: available)
        }
        let filtered = requestsForID.filter { $0.MD5 == request.MD5 }
        guard filtered.isEmpty else {
            throw RequestGrouppedRequestList.Errors.dublicate
        }
        request.addGroup(groupId)
        requestsForID.append(request)
        list[groupId] = requestsForID
    }

    func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol, completion: @escaping CancelCompletion) {
        guard let requests = list[groupId]?.compactMap({ $0 }), !requests.isEmpty else {
            return
        }
        for request in requests {
            do {
                try request.cancel(byReason: reason)
            } catch {
                appContext.logInspector?.log(.warning(error: error), sender: self)
            }
            completion(request, reason)
        }
    }

    func removeRequest(_ request: RequestProtocol) {
        for group in request.availableInGroups {
            if var grouppedRequests = list[group] {
                let cnt = grouppedRequests.count
                grouppedRequests.removeAll(where: { $0.MD5 == request.MD5 })
                assert(grouppedRequests.count != cnt, "not removed")
                if grouppedRequests.isEmpty {
                    list.removeValue(forKey: group)
                } else {
                    list[group] = grouppedRequests
                }
            }
        }
        if list.keys.isEmpty {
            appContext.logInspector?.log(.flow(name: "group", message: "End: <\(String(describing: request))>"), sender: self)
        }
    }
}

// MARK: - %t + RequestGrouppedRequestList.Errors

extension RequestGrouppedRequestList {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case dublicate

        var description: String {
            switch self {
            case .dublicate: return "[\(type(of: self))]: Dublicate"
            }
        }
    }
}

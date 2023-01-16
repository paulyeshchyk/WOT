//
//  RequestGrouppedListenerList.swift
//  WOTKit
//
//  Created by Paul on 16.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - RequestGrouppedListenerList

class RequestGrouppedListenerList {

    private var list = [AnyHashable: [RequestManagerListenerProtocol]]()

    // MARK: Internal

    func didStartRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol) {
        list[request.MD5]?.forEach {
            $0.requestManager(requestManager, didStartRequest: request)
        }
    }

    func didCancelRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, reason: RequestCancelReasonProtocol) {
        list[request.MD5]?.forEach {
            $0.requestManager(requestManager, didCancelRequest: request, reason: reason)
        }
    }

    func didParseDataForRequest(_ request: RequestProtocol, requestManager: RequestManagerProtocol, error: Error?) {
        list[request.MD5]?.forEach { listener in
            listener.requestManager(requestManager, didParseDataForRequest: request, error: error)
        }
    }

    func addListener(_ listener: RequestManagerListenerProtocol, forRequest: RequestProtocol) throws {
        let requestMD5 = forRequest.MD5
        if var listeners = list[requestMD5] {
            let filtered = listeners.filter { $0.MD5 == listener.MD5 }
            guard filtered.isEmpty else {
                throw RequestGrouppedListenerList.Errors.dublicate
            }
            listeners.append(listener)
            list[requestMD5] = listeners
        } else {
            list[requestMD5] = [listener]
        }
    }

    func removeListener(_ listener: RequestManagerListenerProtocol) {
        for MD5 in list.keys {
            if var listeners = list[MD5] {
                listeners.removeAll(where: { $0.MD5 == listener.MD5 })
                list[MD5] = listeners
            }
        }
    }
}

// MARK: - %t + RequestGrouppedListenerList.Errors

extension RequestGrouppedListenerList {
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

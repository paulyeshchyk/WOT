//
//  ResponseManagerListenerList.swift
//  ContextSDK
//
//  Created by Paul on 17.01.23.
//

// MARK: - ResponseManagerListener

@objc
public protocol ResponseManagerListener: MD5Protocol {
    func responseManager(_ responseManager: ResponseManagerProtocol, didStartWorkOn: RequestProtocol)
    func responseManager(_ responseManager: ResponseManagerProtocol, didFinishWorkOn: RequestProtocol, withError: Error?)
    func responseManager(_ responseManager: ResponseManagerProtocol, didCancelWorkOn: RequestProtocol, reason: ResponseCancelReasonProtocol)
}

// MARK: - ListenerListContainerProtocol

@objc
public protocol ListenerListContainerProtocol {
    func addListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol) throws
    func removeListener(_ listener: ResponseManagerListener)
    func removeListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol)
}

// MARK: - ResponseManagerListenerList

class ResponseManagerListenerList {

    private var list = [AnyHashable: [ResponseManagerListener]]()

    // MARK: Internal

    func responseManager(_ responseManager: ResponseManagerProtocol, didStartRequest request: RequestProtocol) {
        list[request.MD5]?.forEach {
            $0.responseManager(responseManager, didStartWorkOn: request)
        }
    }

    func didCancelRequest(_ request: RequestProtocol, requestManager: ResponseManagerProtocol, reason: ResponseCancelReasonProtocol) {
        list[request.MD5]?.forEach {
            $0.responseManager(requestManager, didCancelWorkOn: request, reason: reason)
        }
    }

    func responseManager(_ responseManager: ResponseManagerProtocol, didParseDataForRequest request: RequestProtocol, error: Error?) {
        list[request.MD5]?.forEach { listener in
            listener.responseManager(responseManager, didFinishWorkOn: request, withError: error)
        }
    }
}

// MARK: - ResponseManagerListenerList + ListenerListContainerProtocol

extension ResponseManagerListenerList: ListenerListContainerProtocol {

    func addListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol) throws {
        let requestMD5 = forRequest.MD5
        #warning("Crash is here")
        if var listeners = list[requestMD5] {
            let filtered = listeners.filter { $0.MD5 == listener.MD5 }
            guard filtered.isEmpty else {
                throw ResponseManagerListenerList.Errors.dublicate
            }
            listeners.append(listener)
            list[requestMD5] = listeners
        } else {
            list[requestMD5] = [listener]
        }
    }

    func removeListener(_ listener: ResponseManagerListener) {
        for MD5 in list.keys {
            if var listeners = list[MD5] {
                listeners.removeAll(where: { $0.MD5 == listener.MD5 })
                list[MD5] = listeners
            }
        }
    }

    func removeListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol) {
        let MD5 = forRequest.MD5
        #warning("Crash is here")
        if var listeners = list[MD5] {
            listeners.removeAll(where: { $0.MD5 == listener.MD5 })
            list[MD5] = listeners
        }
    }
}

// MARK: - %t + ResponseManagerListenerList.Errors

extension ResponseManagerListenerList {
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

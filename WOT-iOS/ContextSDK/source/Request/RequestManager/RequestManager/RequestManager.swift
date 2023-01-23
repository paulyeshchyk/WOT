//
//  WOTRequestManager.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestManager

@objc
open class RequestManager: NSObject {

    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & HostConfigurationContainerProtocol
        & ResponseManagerContainerProtocol

    override public var description: String { String(describing: type(of: self)) }

    public var MD5: String { uuid.MD5 }

    private let uuid = UUID()
    private let appContext: Context

    private let grouppedListenerList: RequestGrouppedListenerList
    private let grouppedRequestList: RequestGrouppedRequestList

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
        grouppedRequestList = RequestGrouppedRequestList(appContext: appContext)
        grouppedListenerList = RequestGrouppedListenerList()
        super.init()
    }

    deinit {
        //
    }
}

// MARK: - RequestManager + RequestListenerProtocol

extension RequestManager: RequestListenerProtocol {

    public func request(_ request: RequestProtocol, startedWith _: URLRequest) {
        grouppedListenerList.didStartRequest(request, requestManager: self)
    }

    public func request(_ request: RequestProtocol, canceledWith _: Error?) {
        removeRequest(request)
    }

    public func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?) {
        defer {
            removeRequest(request)
        }

        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
            return
        }

        do {
            try appContext.responseManager?.addListener(self, forRequest: request)
            appContext.responseManager?.startWorkingOn(request, withData: data)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}

extension RequestManager {

    private func removeRequest(_ request: RequestProtocol) {
        grouppedRequestList.removeRequest(request)
        request.removeListener(self)
    }
}

// MARK: - RequestManager + ResponseManagerListener

extension RequestManager: ResponseManagerListener {
    //
    public func responseManager(_: ResponseManagerProtocol, didStartWorkOn _: RequestProtocol) {
        //
    }

    public func responseManager(_ responseManager: ResponseManagerProtocol, didFinishWorkOn request: RequestProtocol, withError error: Error?) {
        responseManager.removeListener(self, forRequest: request)
        grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: error)
        if let error = error {
            appContext.logInspector?.log(.error(error), sender: self)
        }

        removeRequest(request)
    }

    public func responseManager(_ responseManager: ResponseManagerProtocol, didCancelWorkOn request: RequestProtocol, reason: ResponseCancelReasonProtocol) {
        responseManager.removeListener(self, forRequest: request)

        grouppedListenerList.didParseDataForRequest(request, requestManager: self, error: reason.error)

        removeRequest(request)
    }
}

// MARK: - RequestManager + RequestManagerProtocol

extension RequestManager: RequestManagerProtocol {

    public func startRequest(_ request: RequestProtocol, listener: RequestManagerListenerProtocol?) throws {
        //
        try grouppedRequestList.addRequest(request, forGroupId: request.MD5.hashValue)

        request.addListener(self)

        if let listener = listener {
            try grouppedListenerList.addListener(listener, forRequest: request)
        } else {
            appContext.logInspector?.log(.warning(error: Errors.requestManagerListenerIsNil), sender: self)
        }

        try request.start()
    }

    public func cancelRequests(groupId: RequestIdType, reason: RequestCancelReasonProtocol) {
        //
        grouppedRequestList.cancelRequests(groupId: groupId, reason: reason) { [weak self] request, reason in
            guard let self = self else { return }
            self.grouppedListenerList.didCancelRequest(request, requestManager: self, reason: reason)
        }
    }

    public func removeListener(_ listener: RequestManagerListenerProtocol) {
        //
        grouppedListenerList.removeListener(listener)
    }
}

// MARK: - %t + RequestManager.Errors

extension RequestManager {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case adapterNotFound(RequestProtocol)
        case notAModelService(RequestProtocol)
        case noRequestIds(RequestProtocol)
        case requestNotCreated(HttpRequestArgumentsBuilderProtocol)
        case requestsNotRegistered(FetchableProtocol.Type)
        case receivedResponseFromReleasedRequest
        case cantAddListener
        case invalidRequest
        case modelClassNotFound(RequestConfigurationProtocol)
        case modelClassNotRegistered(AnyObject, RequestProtocol)
        case requestManagerListenerIsNil

        public var description: String {
            switch self {
            case .notAModelService(let request): return "\(type(of: self)): Not a model service: \(String(describing: request))"
            case .adapterNotFound(let request): return "\(type(of: self)): Adapter not found for request: \(String(describing: request))"
            case .noRequestIds(let request): return "\(type(of: self)): No request ids for request: \(String(describing: request))"
            case .receivedResponseFromReleasedRequest: return "\(type(of: self)): Received response from released request"
            case .requestNotCreated(let paradigm): return "\(type(of: self)): Request not created for [\(String(describing: paradigm))]"
            case .cantAddListener: return "\(type(of: self)): Can't add listener"
            case .invalidRequest: return "\(type(of: self)): Invalid request"
            case .modelClassNotFound(let configuration): return "\(type(of: self)): Model class not found in configuration: \(String(describing: configuration))"
            case .modelClassNotRegistered(let model, let request): return "\(type(of: self)): Model class(\((type(of: model))) registered for request: \(String(describing: request))"
            case .requestManagerListenerIsNil: return "\(type(of: self)): RequestManagerListener is nil"
            case .requestsNotRegistered(let modelClass): return "[\(type(of: self))]: Request was not registered for [\(String(describing: modelClass))]"
            }
        }
    }
}

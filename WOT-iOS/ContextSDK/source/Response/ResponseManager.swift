//
//  ResponseManager.swift
//  ContextSDK
//
//  Created by Paul on 17.01.23.
//

// MARK: - ResponseManagerContainerProtocol

@objc
public protocol ResponseManagerContainerProtocol {
    var responseManager: ResponseManagerProtocol? { get }
}

// MARK: - ResponseManagerProtocol

@objc
public protocol ResponseManagerProtocol: ListenerListContainerProtocol {

    func startWorkingOn(_ request: RequestProtocol, withData: Data?)
}

// MARK: - ResponseManager

open class ResponseManager: ResponseManagerProtocol {

    private let appContext: ResponseConfigurationProtocol.Context

    private let listeners = ResponseManagerListenerList()

    public init(appContext: ResponseConfigurationProtocol.Context) {
        self.appContext = appContext
    }

    public func startWorkingOn(_ request: RequestProtocol, withData _: Data?) {
        listeners.responseManager(self, didStartRequest: request)
    }
}

// MARK: - ResponseManager + ListenerListContainerProtocol

extension ResponseManager {
    //
    public func removeListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol) {
        listeners.removeListener(listener, forRequest: forRequest)
    }

    public func addListener(_ listener: ResponseManagerListener, forRequest: RequestProtocol) throws {
        try listeners.addListener(listener, forRequest: forRequest)
    }

    public func removeListener(_ listener: ResponseManagerListener) {
        listeners.removeListener(listener)
    }
}

// MARK: - %t + ResponseManager.Errors

extension ResponseManager {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case modelNotFound(RequestProtocol)

        public var description: String {
            switch self {
            case .modelNotFound(let request): return "\(type(of: self)): Model not found for request: \(String(describing: request))"
            }
        }
    }
}

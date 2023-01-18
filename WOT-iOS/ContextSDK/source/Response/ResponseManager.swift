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

    func startWorkingOn(_ request: RequestProtocol, withData: Data?, linker: ManagedObjectLinkerProtocol?, extractor: ManagedObjectExtractable?)
}

// MARK: - ResponseManager

open class ResponseManager: ResponseManagerProtocol {

    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & DecoderManagerContainerProtocol

    private let appContext: Context

    private let listeners = ResponseManagerListenerList()

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public func startWorkingOn(_ request: RequestProtocol, withData data: Data?, linker: ManagedObjectLinkerProtocol?, extractor: ManagedObjectExtractable?) {
        do {
            guard let modelService = request as? RequestModelServiceProtocol else {
                throw Errors.modelNotFound(request)
            }

            guard let modelClass = type(of: modelService).modelClass() else {
                throw Errors.modelNotFound(request)
            }

            listeners.responseManager(self, didStartRequest: request)

            let dataAdapter = type(of: modelService).dataAdapterClass().init(appContext: appContext, modelClass: modelClass)
            dataAdapter.request = request
            dataAdapter.linker = linker
            dataAdapter.extractor = extractor
            dataAdapter.completion = { request, error in
                self.listeners.responseManager(self, didParseDataForRequest: request, error: error)
            }
            dataAdapter.decode(data: data, fromRequest: request)
        } catch {
            listeners.responseManager(self, didParseDataForRequest: request, error: error)
        }
    }

}

// MARK: - ResponseManager + ListenerListContainerProtocol

extension ResponseManager {
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

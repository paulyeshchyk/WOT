//
//  WOTRequestCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestIdType = String

@objc
public protocol WOTDataResponseAdapterProtocol: NSObjectProtocol {
    init(appManager: WOTAppManagerProtocol?, clazz: PrimaryKeypathProtocol.Type)
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, onObjectDidFetch: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete ) -> JSONAdapterProtocol
}

@objc
public protocol WOTRequestCoordinatorProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]?
    func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]?
    func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol) throws -> DataAdapterProtocol
}

public protocol WOTRequestBindingProtocol {
    func unregisterDataAdapter(for requestId: WOTRequestIdType)
    func dataAdapterClass(for requestId: WOTRequestIdType) -> DataAdapterProtocol.Type?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: DataAdapterProtocol.Type)
    func request(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type?
}

public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {
    private var registeredRequests: [WOTRequestIdType: WOTModelServiceProtocol.Type] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: DataAdapterProtocol.Type] = .init()
    public var appManager: WOTAppManagerProtocol?

    override public init() {
        super.init()
        //
    }

    // MARK: - WOTRequestCoordinatorProtocol
    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        guard
            let Clazz = request(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self),
            let result = Clazz.init() as? WOTRequestProtocol else {
            throw RequestCoordinatorError.requestNotFound
        }
        return result
    }

    public func requestIds(forClass: AnyClass) -> [WOTRequestIdType]? {
        let result =  registeredRequests.keys.filter { key in
            if let requestClass = registeredRequests[key] {
                if let requestModelClass = requestClass.modelClass() {
                    return forClass == requestModelClass
                }
            }
            return false
        }
        return result
    }

    public func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]? {
        guard let modelClass = modelClass(for: request) else {
            appManager?.logInspector?.log(ErrorLog(message: "model class not found for request\(request.description)"), sender: self)
            return nil
        }

        guard let result = requestIds(forClass: modelClass), result.count > 0 else {
            appManager?.logInspector?.log(ErrorLog(message: "\(type(of: modelClass)) was not registered for request \(type(of: request))"), sender: self)
            return nil
        }
        return result
    }

    public func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol) throws -> DataAdapterProtocol {
        guard let modelClass = try modelClass(for: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType.description)
        }
        guard let dataResponseAdapterType = dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType.debugDescription)
        }

        return dataResponseAdapterType.init(Clazz: modelClass, request: request, appManager: appManager)
    }
}

extension WOTRequestCoordinator: WOTRequestBindingProtocol {
    // MARK: - WOTRequestBindingProtocol

    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: DataAdapterProtocol.Type) {
        registeredRequests[requiestId] = requestClass
        registeredDataAdapters[requiestId] = dataAdapterClass
    }

    public func unregisterDataAdapter(for requestId: WOTRequestIdType) {
        registeredDataAdapters.removeValue(forKey: requestId)
    }

    public func dataAdapterClass(for requestId: WOTRequestIdType) -> DataAdapterProtocol.Type? {
        return registeredDataAdapters[requestId]
    }

    public func request(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type? {
        return registeredRequests[requestId]
    }
}

public protocol WOTRequestModelBindingProtocol {
    func modelClass(for request: WOTRequestProtocol) -> PrimaryKeypathProtocol.Type?
    func modelClass(for requestIdType: WOTRequestIdType) throws -> PrimaryKeypathProtocol.Type?
}

extension WOTRequestCoordinator: WOTRequestModelBindingProtocol {

    public func modelClass(for request: WOTRequestProtocol) -> PrimaryKeypathProtocol.Type? {
        guard let clazz = type(of: request) as? WOTModelServiceProtocol.Type else { return nil }
        return clazz.modelClass()
    }

    public func modelClass(for requestIdType: WOTRequestIdType) throws -> PrimaryKeypathProtocol.Type? {
        guard let requestClass = registeredRequests[requestIdType] else {
            throw RequestCoordinatorError.requestClassNotFound(requestType: requestIdType.description)
        }

        return requestClass.modelClass()
    }

}

extension WOTRequestCoordinator: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

public enum RequestCoordinatorError: Error {
    case dataIsEmpty
    case requestNotFound
    case adapterNotFound(requestType: String)
    case modelClassNotFound(requestType: String)
    case requestClassNotFound(requestType: String)
}

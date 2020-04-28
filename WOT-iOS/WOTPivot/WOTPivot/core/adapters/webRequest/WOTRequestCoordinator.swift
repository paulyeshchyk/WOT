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
public protocol WOTRequestDataBindingProtocol {
    static func unregisterDataAdapter(for requestId: WOTRequestIdType)
    static func dataAdapterClass(for requestId: WOTRequestIdType) -> DataAdapterProtocol.Type?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: DataAdapterProtocol.Type)
    func request(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type?
}

@objc
public protocol WOTDataResponseAdapterProtocol: NSObjectProtocol {
    init(appManager: WOTAppManagerProtocol?, clazz: PrimaryKeypathProtocol.Type)
    func request(_ request: WOTRequestProtocol, parseData binary: Data?, onObjectDidFetch: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete ) -> JSONAdapterProtocol
}

@objc
public protocol WOTRequestDatasourceProtocol {
    func createRequest(forRequestId: WOTRequestIdType) throws -> WOTRequestProtocol
    func add(request: WOTRequestProtocol, byGroupId: String) -> Bool
    func cancelRequests(byGroupId: String) -> Bool
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]?
}

@objc
public protocol WOTRequestDataParserProtocol {
    func request(_ request: WOTRequestProtocol, parseData: Data?, onObjectDidParse: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete ) throws
}

@objc
public protocol WOTRequestCoordinatorProtocol: WOTRequestDataBindingProtocol, WOTRequestDatasourceProtocol, WOTRequestDataParserProtocol {
    var appManager: WOTAppManagerProtocol? { get set }
}

public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {
    private static var registeredRequests: [WOTRequestIdType: WOTModelServiceProtocol.Type] = .init()
    private static var registeredDataAdapters: [WOTRequestIdType: DataAdapterProtocol.Type] = .init()
    public var appManager: WOTAppManagerProtocol?

    // MARK: - WOTRequestDataBindingProtocol
    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: WOTModelServiceProtocol.Type, registerDataAdapterClass dataAdapterClass: DataAdapterProtocol.Type) {
        WOTRequestCoordinator.registeredRequests[requiestId] = requestClass
        WOTRequestCoordinator.registeredDataAdapters[requiestId] = dataAdapterClass
    }

    public static func unregisterDataAdapter(for requestId: WOTRequestIdType) {
        WOTRequestCoordinator.registeredDataAdapters.removeValue(forKey: requestId)
    }

    public static func dataAdapterClass(for requestId: WOTRequestIdType) -> DataAdapterProtocol.Type? {
        return WOTRequestCoordinator.registeredDataAdapters[requestId]
    }

    public func request(for requestId: WOTRequestIdType) -> WOTModelServiceProtocol.Type? {
        return WOTRequestCoordinator.registeredRequests[requestId]
    }

    // MARK: - WOTRequestDatasourceProtocol
    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        guard
            let Clazz = request(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self),
            let result = Clazz.init() as? WOTRequestProtocol else {
            throw RequestCoordinatorError.requestNotFound
        }
        return result
    }

    public func add(request: WOTRequestProtocol, byGroupId: String) -> Bool {
        return false
    }

    public func cancelRequests(byGroupId: String) -> Bool {
        return false
    }

    public func requestIds(forClass: AnyClass) -> [WOTRequestIdType]? {
        let result =  WOTRequestCoordinator.registeredRequests.keys.filter { key in
            if let requestClass = WOTRequestCoordinator.registeredRequests[key] {
                if let requestModelClass = requestClass.modelClass() {
                    return forClass == requestModelClass
                }
            }
            return false
        }
        return result
    }

    // MARK: - WOTRequestDataParserProtocol
    static func modelClass(for request: WOTRequestProtocol) -> PrimaryKeypathProtocol.Type? {
        guard let clazz = type(of: request) as? WOTModelServiceProtocol.Type else { return nil }
        return clazz.modelClass()
    }

    static func modelClass(for requestIdType: WOTRequestIdType) throws -> PrimaryKeypathProtocol.Type? {
        guard let requestClass = WOTRequestCoordinator.registeredRequests[requestIdType] else {
            throw RequestCoordinatorError.requestClassNotFound(requestType: requestIdType)
        }

        return requestClass.modelClass()
    }

    private func responseAdapterInstance(for requestIdType: WOTRequestIdType, request: WOTRequestProtocol) throws -> DataAdapterProtocol {
        guard let modelClass = try WOTRequestCoordinator.modelClass(for: requestIdType) else {
            throw RequestCoordinatorError.modelClassNotFound(requestType: requestIdType)
        }
        guard let dataResponseAdapterType = WOTRequestCoordinator.dataAdapterClass(for: requestIdType) else {
            throw RequestCoordinatorError.adapterNotFound(requestType: requestIdType)
        }

        return dataResponseAdapterType.init(Clazz: modelClass, request: request, appManager: appManager)
    }

    private func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType]? {
        guard let modelClass = WOTRequestCoordinator.modelClass(for: request) else {
            appManager?.logInspector?.log(ErrorLog("model class not found for request\(request.description)"), sender: self)
            return nil
        }

        guard let result = requestIds(forClass: modelClass), result.count > 0 else {
            appManager?.logInspector?.log(ErrorLog("\(type(of: modelClass)) was not registered for request \(type(of: request))"), sender: self)
            return nil
        }
        return result
    }

    public func request( _ request: WOTRequestProtocol, parseData: Data?, onObjectDidParse: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        guard let requestIds = requestIds(forRequest: request), requestIds.count > 0 else {
            onRequestComplete(request, self, nil)
            return
        }
        var dataAdaptationPair: [DataAdaptationPair] = .init()
        requestIds.forEach({ requestIdType in
            do {
                let adapter = try responseAdapterInstance(for: requestIdType, request: request)
                adapter.onComplete = onRequestComplete
                adapter.onObjectDidParse = onObjectDidParse
                let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
                dataAdaptationPair.append(pair)
            } catch let error {
                appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            }
        })

        if dataAdaptationPair.count == 0 {
            onRequestComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { (pair) in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }
}

struct DataAdaptationPair {
    let dataAdapter: DataAdapterProtocol
    let data: Data?
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

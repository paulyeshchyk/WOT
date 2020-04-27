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
    static func dataAdapter(for requestId: WOTRequestIdType) -> AnyClass?
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass, registerDataAdapterClass dataAdapterClass: AnyClass)
    func request(for requestId: WOTRequestIdType) -> AnyClass?
}

@objc
public protocol WOTRequestDatasourceProtocol {
    @objc
    func register(_ request: Any)

    @objc
    func createRequest(forRequestId: WOTRequestIdType) -> WOTRequestProtocol?

    @objc
    func add(request: WOTRequestProtocol, byGroupId: String) -> Bool

    @objc
    func cancelRequests(byGroupId: String) -> Bool

    @objc
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]?
}

@objc
public protocol WOTRequestDataParserProtocol {
    @objc
    func request(_ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish )
}

@objc
public protocol WOTRequestCoordinatorProtocol: WOTRequestDataBindingProtocol, WOTRequestDatasourceProtocol, WOTRequestDataParserProtocol {
    @objc
    var appManager: WOTAppManagerProtocol? { get set }
}

@objc
public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {
    private static var registeredRequests: [WOTRequestIdType: AnyClass] = .init()
    private static var registeredDataAdapters: [WOTRequestIdType: AnyClass] = .init()
    public var appManager: WOTAppManagerProtocol?

    // MARK: - WOTRequestDataBindingProtocol
    @objc
    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass, registerDataAdapterClass dataAdapterClass: AnyClass) {
        WOTRequestCoordinator.registeredRequests[requiestId] = requestClass
        WOTRequestCoordinator.registeredDataAdapters[requiestId] = dataAdapterClass
    }

    @objc
    public static func unregisterDataAdapter(for requestId: WOTRequestIdType) {
        WOTRequestCoordinator.registeredDataAdapters.removeValue(forKey: requestId)
    }

    @objc
    public static func dataAdapter(for requestId: WOTRequestIdType) -> AnyClass? {
        return WOTRequestCoordinator.registeredDataAdapters[requestId]
    }

    @objc
    public func request(for requestId: WOTRequestIdType) -> AnyClass? {
        return WOTRequestCoordinator.registeredRequests[requestId]
    }

    // MARK: - WOTRequestDatasourceProtocol
    @objc
    public func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol? {
        guard
            let Clazz = request(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self),
            let result = Clazz.init() as? WOTRequestProtocol else {
            return nil
        }
        return result
    }

    @objc
    public func register(_ request: Any) {}

    @objc
    public func add(request: WOTRequestProtocol, byGroupId: String) -> Bool {
        return false
    }

    @objc
    public func cancelRequests(byGroupId: String) -> Bool {
        return false
    }

    @objc
    public func requestIds(forClass: AnyClass) -> [WOTRequestIdType]? {
        let result =  WOTRequestCoordinator.registeredRequests.keys.filter { key in
            if let requestClass = WOTRequestCoordinator.registeredRequests[key], requestClass.conforms(to: WOTModelServiceProtocol.self) {
                if let requestModelClass = requestClass.modelClass() {
                    return forClass == requestModelClass
                }
            }
            return false
        }
        return result
    }

    // MARK: - WOTRequestDataParserProtocol
    static func modelClass(for request: WOTRequestProtocol) -> AnyClass? {
        guard let clazz = type(of: request) as? NSObject.Type else { return nil }
        guard let instance = clazz.init() as? WOTModelServiceProtocol else { return nil}
        guard let modelClass = instance.instanceModelClass() else { return nil}
        return modelClass
    }

    private func adapterInstance(for requestIdType: WOTRequestIdType) throws -> WOTWebResponseAdapterProtocol {
        guard let AdapterType = WOTRequestCoordinator.dataAdapter(for: requestIdType) else {
            throw DataAdapterError.adapterNotFound(requestType: requestIdType)
        }

        guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapterProtocol else {
            throw DataAdapterError.classIsNotDataAdapter(dataAdapter: String(describing: AdapterType))
        }
        adapter.appManager = appManager
        return adapter
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

    #warning("to be refactored")
    @objc
    public func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish) {
        guard let requestIds = requestIds(forRequest: request), requestIds.count > 0 else {
            onFinish(self, nil)
            return
        }
        var coreDataStoreStack: [CoreDataStorePair] = .init()
        requestIds.forEach({ requestIdType in
            do {
                let adapter = try adapterInstance(for: requestIdType)
                let store = adapter.request(request, parseData: binary, jsonLinkAdapter: jsonLinkAdapter, onCreateNSManagedObject: onCreateNSManagedObject, onFinish: onFinish)
                let pair = CoreDataStorePair(coreDataStore: store, data: binary)
                coreDataStoreStack.append(pair)
            } catch let error {
                appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            }

        })

        if coreDataStoreStack.count == 0 {
            onFinish(self, nil)
        }

        coreDataStoreStack.forEach { (pair) in
            pair.coreDataStore.perform(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }
}

struct CoreDataStorePair {
    let coreDataStore: JSONCoordinatorProtocol
    let data: Data?
}

extension WOTRequestCoordinator: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

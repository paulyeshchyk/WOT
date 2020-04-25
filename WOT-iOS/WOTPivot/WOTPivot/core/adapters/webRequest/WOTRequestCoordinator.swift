//
//  WOTRequestCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestCompletion = () -> Void
public typealias WOTRequestIdType = String

public typealias  WOTRequestCallback = (Data?, Error?) -> Void

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
    func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, subordinateLinks: [WOTJSONLink]?, externalCallback: NSManagedObjectCallback?, onFinish: @escaping ((Error?) -> Void))
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
        let result: AnyClass? = WOTRequestCoordinator.registeredRequests[requestId]
        if result == nil {
            appManager?.logInspector?.log(ErrorLog("request not found:\(requestId)"), sender: self)
        }
        return result
    }

    // MARK: - WOTRequestDatasourceProtocol
    @objc
    public func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol? {
        guard let Clazz = request(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self) else {
            appManager?.logInspector?.log(ErrorLog("request clazz not found:\(requestId)"), sender: self)
            return nil
        }
        guard let result = Clazz.init() as? WOTRequestProtocol else {
            appManager?.logInspector?.log(ErrorLog("request not created:\(String(describing: Clazz))"), sender: self)
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
            guard let requestClass = WOTRequestCoordinator.registeredRequests[key], requestClass.conforms(to: WOTModelServiceProtocol.self) else { return false }
            guard let requestModelClass = requestClass.modelClass() else { return false }
            guard forClass == requestModelClass else { return false }
            return true
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

    private func adapterInstance(for requestIdType: WOTRequestIdType) -> WOTWebResponseAdapterProtocol? {
        guard let AdapterType = WOTRequestCoordinator.dataAdapter(for: requestIdType) else {
            appManager?.logInspector?.log(ErrorLog("dataadapter not found for :\(requestIdType)"))
            return nil
        }

        guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapterProtocol else {
            appManager?.logInspector?.log(ErrorLog("adapter is not conforming protocol WOTWebResponseAdapter :\(requestIdType)"))
            return nil
        }
        adapter.appManager = appManager
        return adapter
    }

    @objc
    public func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, subordinateLinks: [WOTJSONLink]?, externalCallback: NSManagedObjectCallback?, onFinish: @escaping ((Error?) -> Void) ) {
        guard let modelClass = WOTRequestCoordinator.modelClass(for: request) else {
            appManager?.logInspector?.log(ErrorLog("model class not found for request\(request.description)"), sender: self)
            onFinish(nil)
            return
        }

        var coreDataStoreStack: [CoreDataStoreProtocol] = .init()
        let requestIdTypes = self.requestIds(forClass: modelClass)
        requestIdTypes?.forEach({ requestIdType in

            if let adapter = adapterInstance(for: requestIdType) {
                let store = adapter.request(request, parseData: binary, jsonLinkAdapter: jsonLinkAdapter, subordinateLinks: subordinateLinks, externalCallback: externalCallback, onFinish: onFinish)
                coreDataStoreStack.append(store)
            } else {
                appManager?.logInspector?.log(ErrorLog("Adapter not found for \(requestIdType)"), sender: self)
            }
        })

        if coreDataStoreStack.count == 0 {
            onFinish(nil)
        }

        coreDataStoreStack.forEach { (store) in
            store.perform()
        }
    }
}

extension WOTRequestCoordinator: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: type(of: self))
    }
}

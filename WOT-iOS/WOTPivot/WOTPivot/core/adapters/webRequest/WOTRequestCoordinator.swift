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
    @objc
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass, registerDataAdapterClass dataAdapterClass: AnyClass)

    @objc
    static func unregisterDataAdapter(for requestId: WOTRequestIdType)

    @objc
    static func dataAdapter(for requestId: WOTRequestIdType) -> AnyClass?

    @objc
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
    func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ((Error?) -> Void))
}

@objc
public protocol WOTRequestCoordinatorProtocol: WOTRequestDataBindingProtocol, WOTRequestDatasourceProtocol, WOTRequestDataParserProtocol {
    @objc
    static var logInspector: LogInspectorProtocol? { get set }

    @objc
    var appManager: WOTAppManagerProtocol? { get set }
}

@objc
public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {
    private static var registeredRequests: [WOTRequestIdType: AnyClass] = .init()
    private static var registeredDataAdapters: [WOTRequestIdType: AnyClass] = .init()
    public static var logInspector: LogInspectorProtocol?
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
            WOTRequestCoordinator.logInspector?.log(ErrorLog("request not found:\(requestId)"), sender: self)
        }
        return result
    }

    // MARK: - WOTRequestDatasourceProtocol
    @objc
    public func createRequest(forRequestId requestId: WOTRequestIdType) -> WOTRequestProtocol? {
        guard let Clazz = request(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self) else {
            WOTRequestCoordinator.logInspector?.log(ErrorLog("request clazz not found:\(requestId)"), sender: self)
            return nil
        }
        guard let result = Clazz.init() as? WOTRequestProtocol else {
            WOTRequestCoordinator.logInspector?.log(ErrorLog("request not created:\(String(describing: Clazz))"), sender: self)
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

    static func adapterInstance(for requestIdType: WOTRequestIdType) -> WOTWebResponseAdapterProtocol? {
        guard let AdapterType = WOTRequestCoordinator.dataAdapter(for: requestIdType) else {
            WOTRequestCoordinator.logInspector?.log(ErrorLog("dataadapter not found for :\(requestIdType)"))
            return nil
        }

        guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapterProtocol else {
            WOTRequestCoordinator.logInspector?.log(ErrorLog("adapter is not conforming protocol WOTWebResponseAdapter :\(requestIdType)"))
            return nil
        }
        return adapter
    }

    @objc
    public func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ((Error?) -> Void) ) {
        guard let modelClass = WOTRequestCoordinator.modelClass(for: request) else { return }

        var coreDataStoreStack: [CoreDataStoreProtocol] = .init()
        let requestIdTypes = self.requestIds(forClass: modelClass)
        requestIdTypes?.forEach({ requestIdType in
            guard let adapter = WOTRequestCoordinator.adapterInstance(for: requestIdType) else {
                WOTRequestCoordinator.logInspector?.log(ErrorLog("Adapter not found for :\(requestIdType)"), sender: self)
                return
            }
            let store = adapter.request(request, parseData: binary, jsonLinkAdapter: jsonLinkAdapter, subordinateLinks: subordinateLinks, onFinish: onFinish)
            coreDataStoreStack.append(store)
        })

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

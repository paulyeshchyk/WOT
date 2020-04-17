//
//  WOTRequestCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestCompletion = () -> Void
public typealias WOTRequestIdType = Int

public typealias  WOTRequestCallback = (Data?, Error?) -> Void

@objc
public protocol WOTRequestDataBindingProtocol {
    @objc
    func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass, registerDataAdapterClass dataAdapterClass: AnyClass)

    @objc
    func unregisterDataAdapter(for requestId: WOTRequestIdType)

    @objc
    func dataAdapter(for requestId: WOTRequestIdType) -> AnyClass?

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
    func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapter)
}

@objc
public protocol WOTRequestCoordinatorProtocol: WOTRequestDataBindingProtocol, WOTRequestDatasourceProtocol, WOTRequestDataParserProtocol {}

@objc
public class WOTRequestCoordinator: NSObject {
    private var registeredRequests: [WOTRequestIdType: AnyClass] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: AnyClass] = .init()
}

extension WOTRequestCoordinator: WOTRequestDataBindingProtocol {
    @objc
    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass, registerDataAdapterClass dataAdapterClass: AnyClass) {
        self.registeredRequests[requiestId] = requestClass
        self.registeredDataAdapters[requiestId] = dataAdapterClass
    }

    @objc
    public func unregisterDataAdapter(for requestId: WOTRequestIdType) {
        self.registeredDataAdapters.removeValue(forKey: requestId)
    }

    @objc
    public func dataAdapter(for requestId: WOTRequestIdType) -> AnyClass? {
        return self.registeredDataAdapters[requestId]
    }

    @objc
    public func request(for requestId: WOTRequestIdType) -> AnyClass? {
        return self.registeredRequests[requestId]
    }
}

extension WOTRequestCoordinator: WOTRequestDatasourceProtocol {
    @objc
    public func createRequest(forRequestId: WOTRequestIdType) -> WOTRequestProtocol? {
        guard let Clazz = request(for: forRequestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self) else {
            return nil
        }
        guard let result = Clazz.init() as? WOTRequestProtocol else {
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
        let result =  self.registeredRequests.keys.filter { key in
            guard let requestClass = self.registeredRequests[key], requestClass.conforms(to: WOTModelServiceProtocol.self) else { return false }
            guard let requestModelClass = requestClass.modelClass() else { return false }
            guard forClass == requestModelClass else { return false }
            return true
        }
        return result
    }
}

extension WOTRequestCoordinator: WOTRequestDataParserProtocol {
    static func modelClass(for request: WOTRequestProtocol) -> AnyClass? {
        guard let clazz = type(of: request) as? NSObject.Type else { return nil }
        guard let instance = clazz.init() as? WOTModelServiceProtocol else { return nil}
        guard let modelClass = instance.instanceModelClass() else { return nil}
        return modelClass
    }

    #warning("make static")
    func adapterInstance(for requestIdType: WOTRequestIdType) -> WOTWebResponseAdapter? {
        guard let AdapterType = self.dataAdapter(for: requestIdType) else {
            print("dataadapter not found")
            return nil
        }

        guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapter else {
            print("adapter is not WOTWebResponseAdapter")
            return nil
        }
        return adapter
    }

    @objc
    public func request( _ request: WOTRequestProtocol, processBinary binary: Data?, jsonLinkAdapter: JSONLinksAdapter) {
        guard let modelClass = WOTRequestCoordinator.modelClass(for: request) else { return }

        let requestIdTypes = self.requestIds(forClass: modelClass)
        requestIdTypes?.forEach({ (idType) in
            self.request(request, processBinary: binary, requestIdType: idType, jsonLinkAdapter: jsonLinkAdapter)
        })
    }

    func request(_ request: WOTRequestProtocol, processBinary binary: Data?, requestIdType: WOTRequestIdType, jsonLinkAdapter: JSONLinksAdapter) {
        guard let adapter = self.adapterInstance(for: requestIdType) else { return }

        let error = adapter.request(request, parseData: binary, jsonLinkAdapter: jsonLinkAdapter)
        if let text = (error as? WOTWEBRequestError)?.description ?? error?.localizedDescription {
            print("raized:\(text)")
        }
    }
}

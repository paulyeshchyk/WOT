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
    func processBinary(_ binary: Data?, fromRequest request: WOTRequestProtocol, error: Error?, completion: WOTJSONLinksCallback?)
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
    @objc
    public func processBinary(_ binary: Data?, fromRequest request: WOTRequestProtocol, error: Error?, completion: WOTJSONLinksCallback?) {
        guard let clazz = type(of: request) as? NSObject.Type else { return }
        guard let instance = clazz.init() as? WOTModelServiceProtocol else { return }
        guard let modelClass = instance.instanceModelClass() else { return }

        let requestIds = self.requestIds(forClass: modelClass)
        requestIds?.forEach({ requestId in
            processBinary(binary, requestId: requestId, completion: completion)
        })
    }

    private func processBinary(_ binary: Data?, requestId: WOTRequestIdType, completion: WOTJSONLinksCallback?) {
        guard let AdapterType = self.dataAdapter(for: requestId) else {
            print("dataadapter not found")
            return
        }

        guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapter else {
            print("adapter is not WOTWebResponseAdapter")
            return
        }

        let error = adapter.parseData(binary, jsonLinksCallback: completion)
        if let text = (error as? WOTWEBRequestError)?.description ?? error?.localizedDescription {
            print("\(NSStringFromClass(Clazz)) raized:\(text)")
        }
    }
}

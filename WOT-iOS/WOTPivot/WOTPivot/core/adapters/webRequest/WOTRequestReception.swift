//
//  WOTRequestReception.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol KeypathProtocol: class {
    
    @objc
    static func keypaths() -> [String]
    
    @objc
    func instanceKeypaths() -> [String]
}

public typealias WOTRequestCompletion = () -> Void
public typealias WOTRequestIdType = Int

/*
 typedef NS_ENUM(NSInteger, WOTRequestId) {
     WOTRequestIdLogin = 0,
     WOTRequestIdSaveSession,
     WOTRequestIdLogout,
     WOTRequestIdClearSession,
     WOTRequestIdTanks,
     WOTRequestIdTankEngines,
     WOTRequestIdTankChassis,
     WOTRequestIdTankTurrets,
     WOTRequestIdTankGuns,
     WOTRequestIdTankRadios,
     WOTRequestIdTankVehicles,
     WOTRequestIdTankProfile,
     WOTRequestIdModulesTree
 };

 */

public typealias  WOTRequestCallback = (Data?, Error?) -> Void

@objc
public protocol WOTRequestReceptionProtocol {
    @objc
    func createRequest(forRequestId: WOTRequestIdType) -> WOTRequestProtocol?

    @objc
    func register(_ request: Any)

    @objc
    func add(request: WOTRequestProtocol, byGroupId: String) -> Bool

    @objc
    func cancelRequests(byGroupId: String) -> Bool

    @objc
    func requestId(_ requiestId:WOTRequestIdType, registerRequestClass requestClass: AnyClass)

    @objc
    func request(for requestId: WOTRequestIdType) -> AnyClass?
    
    @objc
    func requestIds(forClass: AnyClass) -> [WOTRequestIdType]?

    @objc
    func requestId(_ requiestId:WOTRequestIdType, registerDataAdapterClass dataAdapterClass: AnyClass)

    @objc
    func unregister(dataAdaprterClass: AnyClass, forRequestId: WOTRequestIdType)
    
    @objc
    func dataAdapter(for requestId: WOTRequestIdType) -> [AnyClass]?

    @objc
    func requestId(_ requestId: WOTRequestIdType, registerRequestCompletion: @escaping WOTRequestCallback)
    
    @objc
    func requestId(_ requestId: WOTRequestIdType, processBinary binary: Data?, error: Error?, completion: (([JSONLinkedObjectRequest]?)->Void)? )
}

@objc
public class WOTRequestReception: NSObject {
    
    private var registeredRequests: [WOTRequestIdType: AnyClass] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: [AnyClass]] = .init()

    @available(*, deprecated, message: "use dataadapters instead")
    private var registeredCallbacks: [WOTRequestIdType: [WOTRequestCallback]] = .init()
    
}

extension WOTRequestReception: WOTRequestReceptionProtocol {
    
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
    public func register(_ request: Any) {
        
    }
    
    @objc
    public func add(request: WOTRequestProtocol, byGroupId: String) -> Bool {
        return false
    }
    
    @objc
    public func cancelRequests(byGroupId: String) -> Bool {
        return false
    }
    
    @objc
    public func requestId(_ requiestId: WOTRequestIdType, registerRequestClass requestClass: AnyClass) {
        self.registeredRequests[requiestId] = requestClass
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
    
    @objc
    public func request(for requestId: WOTRequestIdType) -> AnyClass? {
        return self.registeredRequests[requestId]
    }
    
    @objc
    public func requestId(_ requiestId: WOTRequestIdType, registerDataAdapterClass dataAdapterClass: AnyClass) {
        var array: [AnyClass] = .init()
        if let existance = self.registeredDataAdapters[requiestId] {
            array.append(contentsOf: existance)
        }
        array.append(dataAdapterClass)
        self.registeredDataAdapters[requiestId] = array
    }
    
    @objc
    public func unregister(dataAdaprterClass: AnyClass, forRequestId: WOTRequestIdType) {
        guard var array = self.registeredDataAdapters[forRequestId] else {
            return
        }
        array.removeAll { (existedAdaprterClass) -> Bool in
            existedAdaprterClass == dataAdaprterClass
        }
        self.registeredDataAdapters[forRequestId] = array
    }

    
    @objc
    public func requestId(_ requestId: WOTRequestIdType, registerRequestCompletion completion: @escaping WOTRequestCallback ) {
        var array: [WOTRequestCallback] = .init()
        if let existance = self.registeredCallbacks[requestId] {
            array.append(contentsOf: existance)
        }
        array.append(completion)
        self.registeredCallbacks[requestId] = array
    }

    @objc
    public func dataAdapter(for requestId: WOTRequestIdType) -> [AnyClass]? {
        return self.registeredDataAdapters[requestId]
    }

    @objc
    public func requestId(_ requestId: WOTRequestIdType, processBinary binary: Data?, error: Error?, completion: (([JSONLinkedObjectRequest]?)->Void)? ){

        let callbacks = self.registeredCallbacks[requestId]
        callbacks?.forEach({ callback in
            callback(binary, error)
        })
        
        guard let adapters = self.dataAdapter(for: requestId) else {
            return
        }
        
        adapters.forEach { AdapterType in
            guard let Clazz = AdapterType as? NSObject.Type, let adapter = Clazz.init() as? WOTWebResponseAdapter else {
                return
            }
            let error = adapter.parseData(binary, error: error, linkedObjectsRequestsCallback: { linkedRequests in
                completion?(linkedRequests)
            })
            if let text = (error as? WOTWEBRequestError)?.description ?? error?.localizedDescription {
                print("\(NSStringFromClass(Clazz)) raized:\(text)")
            }
        }
        return
    }
}

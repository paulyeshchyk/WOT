//
//  WOTRequestReception.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

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
    func requestId(_ requestId: WOTRequestIdType, processBinary binary: Data?, error: Error?)
}

@objc
public class WOTRequestReception: NSObject {
    
    private var registeredRequests: [WOTRequestIdType: AnyClass] = .init()
    private var registeredDataAdapters: [WOTRequestIdType: [AnyClass]] = .init()
    private var registeredCallbacks: [WOTRequestIdType: [WOTRequestCallback]] = .init()

    @objc
    public static let sharedInstance = WOTRequestReception()
    
}


extension WOTRequestReception: WOTRequestReceptionProtocol {
    
    @objc
    public func createRequest(forRequestId: WOTRequestIdType) -> WOTRequestProtocol? {
        return nil
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
        var result = [WOTRequestIdType]()
        self.registeredRequests.keys.forEach { (key) in
            if let requestClass = self.registeredRequests[key] {
                let requestClassName = requestClass.modelClassName()
                let forClassClassName = NSStringFromClass(forClass)
                if requestClassName.compare(forClassClassName) == .orderedSame {
                    result.append(key)
                }
            }
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
    public func requestId(_ requestId: WOTRequestIdType, processBinary binary: Data?, error: Error?) {

        let callbacks = self.registeredCallbacks[requestId]
        callbacks?.forEach({ callback in
            callback(error, binary)
        })
        
        guard let adapters = self.dataAdapter(for: requestId) else {
            return
        }
        
        adapters.forEach { AdapterType in
            if let Clazz = AdapterType as? NSObject.Type {
                if let adapter = Clazz.init() as? WOTWebResponseAdapter {
                    adapter.parseData(binary, nestedRequestsCallback: {[weak self] nestedRequests in
                        self?.evaluate(nestedRequests: nestedRequests)
                    })
                }
            }
        }
    }
    
    
    private func evaluate(nestedRequests:[JSONMappingNestedRequest]?) {
//        nestedRequests?.forEach( { request in
//            let requestIDs = self.requestIds(forClass: request.clazz)
//            requestIDs?.forEach({ (requestId) in
//                let arguments = WOTRequestArguments()
//                /*
//                 WOTRequestArguments *arguments = [[WOTRequestArguments alloc] init];
//
//                 NSArray* keypathsSwift = [request.clazz performSelector:@selector(keypaths)];
//
//                 NSMutableArray<NSString *>* keypaths = [[NSMutableArray alloc] init];
//
//                 [keypathsSwift enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                 NSString *keypath = [NSString stringWithString:obj];
//                 [keypaths addObject: keypath];
//                 }];
//                 [arguments setValues:keypaths forKey: @"fields"];
//                 [arguments setValues:@[request.identifier] forKey:request.identifier_fieldname];//TODO: refectoring
//                 [arguments setValues:@[self.hostConfiguration.applicationID] forKey:@"application_id"];
//
//                 id<WOTRequestProtocol> wotRequest = [[WOTRequestExecutor sharedInstance] createRequestForId: [requestID integerValue] ];
//                 BOOL canAdd = [[WOTRequestExecutor sharedInstance] add:wotRequest byGroupId:@"NestedRequest"];
//                 if ( canAdd ) {
//                 [wotRequest start:arguments];
//                 }
//
//                 */
//            })
//        })
    }
}

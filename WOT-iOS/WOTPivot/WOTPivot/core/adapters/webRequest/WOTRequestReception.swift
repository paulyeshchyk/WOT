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
    func register(dataAdapterClass: AnyClass, forRequestId: WOTRequestIdType)

    @objc
    func register(requestCompletion: WOTRequestCompletion, forRequestId: WOTRequestIdType)
}

@objc
public class WOTRequestReception: NSObject {
    
    private var registeredRequests: [AnyHashable: AnyClass] = .init()
    
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
    public func register(dataAdapterClass: AnyClass, forRequestId: WOTRequestIdType) {
        
    }
    
    @objc
    public func register(requestCompletion: WOTRequestCompletion, forRequestId: WOTRequestIdType) {
        
    }

    
}

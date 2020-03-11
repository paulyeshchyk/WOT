//
//  WOTWEBRequestFactory.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestFactory: NSObject {
    
    @objc
    @discardableResult
    public static func performVehicleRequest(vehicleId: Int, hostConfiguration: WOTHostConfigurationProtocol, invokedBy: WOTNestedRequestsEvaluatorProtocol?) -> Bool {
        
        guard let request = WOTRequestReception.sharedInstance.createRequest(forRequestId: WOTRequestId.tankVehicles.rawValue) else {
            return false
        }

        let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"
        guard WOTRequestExecutorSwift.sharedInstance.addRequest(request, forGroupId: groupId) else {
            return false
        }

        let args = WOTRequestArguments()
        args.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicles.keypaths()], forKey: WGWebQueryArgs.fields)
        
        request.hostConfiguration = hostConfiguration

        return request.start(args, invokedBy: invokedBy)
    }

    @objc
    @discardableResult
    public static func performTankProfileRequest(tankId: Int, hostConfiguration: WOTHostConfigurationProtocol, invokedBy: WOTNestedRequestsEvaluatorProtocol?) -> Bool {
        
        guard let request = WOTRequestReception.sharedInstance.createRequest(forRequestId: WOTRequestId.tankProfile.rawValue) else {
            return false
        }
        
        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(tankId)"
        guard WOTRequestExecutorSwift.sharedInstance.addRequest(request, forGroupId: groupId) else {
            return false
        }
        
        let args = WOTRequestArguments()
        args.setValues([tankId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicleprofile.keypaths()], forKey: WGWebQueryArgs.fields)
        
        request.hostConfiguration = hostConfiguration
        
        return request.start(args, invokedBy: invokedBy)
    }

    
}

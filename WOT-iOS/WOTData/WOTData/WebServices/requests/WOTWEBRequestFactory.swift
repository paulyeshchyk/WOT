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
    public static func performVehicleRequest(requestManager: WOTRequestManagerProtocol, vehicleId: Int, hostConfiguration: WOTHostConfigurationProtocol, invokedBy: WOTNestedRequestsEvaluatorProtocol) -> Bool {
        
        guard let request = requestManager.requestReception.createRequest(forRequestId: WOTRequestId.tankVehicles.rawValue) else {
            return false
        }

        let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"
        guard requestManager.addRequest(request, forGroupId: groupId) else {
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
    public static func performTankProfileRequest(requestManager: WOTRequestManagerProtocol, tankId: Int, hostConfiguration: WOTHostConfigurationProtocol, invokedBy: WOTNestedRequestsEvaluatorProtocol) -> Bool {
        
        guard let request = requestManager.requestReception.createRequest(forRequestId: WOTRequestId.tankProfile.rawValue) else {
            return false
        }
        
        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(tankId)"
        guard requestManager.addRequest(request, forGroupId: groupId) else {
            return false
        }
        
        let args = WOTRequestArguments()
        args.setValues([tankId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicleprofile.keypaths()], forKey: WGWebQueryArgs.fields)
        
        request.hostConfiguration = hostConfiguration
        
        return request.start(args, invokedBy: invokedBy)
    }

    
}

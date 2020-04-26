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
    public static func fetchVehiclePivotData(_ requestManager: WOTRequestManagerProtocol?, listener: WOTRequestManagerListenerProtocol)throws {
        let arguments = WOTRequestArguments()
        arguments.setValues(Vehicles.fieldsKeypaths(), forKey: WGWebQueryArgs.fields)

        guard let request = requestManager?.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else {
            throw DataAdapterError.requestNotRegistered(requestType: WebRequestType.vehicles.description)
        }
        requestManager?.addListener(listener, forRequest: request)
        requestManager?.start(request, with: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonLink: nil, onCreateNSManagedObject: nil)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) -> WOTRequestProtocol? {
        guard let request = requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else {
            return nil
        }

        let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"

        let args = WOTRequestArguments()
        args.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicles.classKeypaths()], forKey: WGWebQueryArgs.fields)

        requestManager.start(request, with: args, forGroupId: groupId, jsonLink: nil, onCreateNSManagedObject: nil)
        requestManager.addListener(listener, forRequest: request)
        return request
    }

    @objc
    public static func fetchProfileData(profileTankId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) {
        guard let request = requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue) else {
            return
        }

        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"

        let args = WOTRequestArguments()
        args.setValues([profileTankId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicleprofile.fieldsKeypaths()], forKey: WGWebQueryArgs.fields)

        requestManager.start(request, with: args, forGroupId: groupId, jsonLink: nil, onCreateNSManagedObject: nil)
        requestManager.addListener(listener, forRequest: request)
    }
}

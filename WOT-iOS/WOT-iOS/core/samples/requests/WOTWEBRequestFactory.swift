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
    public static func fetchVehiclePivotData(_ requestManager: WOTRequestManagerProtocol?, listener: WOTRequestManagerListenerProtocol) {
        let arguments = WOTRequestArguments()
        arguments.setValues(Vehicles.keypathsLight(), forKey: WGWebQueryArgs.fields)

        guard let request = requestManager?.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else { return }
        requestManager?.addListener(listener, forRequest: request)
        requestManager?.start(request, with: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonLink: nil, externalCallback: nil)
    }

    @objc
    @discardableResult
    public static func fetchVehicleTreeData(vehicleId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) -> WOTRequestProtocol? {
        guard let request = requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else {
            return nil
        }

        let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"

        let args = WOTRequestArguments()
        args.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicles.keypaths()], forKey: WGWebQueryArgs.fields)

        let started = requestManager.start(request, with: args, forGroupId: groupId, jsonLink: nil, externalCallback: nil)
        requestManager.addListener(listener, forRequest: request)
        return started ? request : nil
    }

    @objc
    @discardableResult
    public static func fetchProfileData(profileTankId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) -> Bool {
        guard let request = requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue) else {
            return false
        }

        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"

        let args = WOTRequestArguments()
        args.setValues([profileTankId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicleprofile.keypaths()], forKey: WGWebQueryArgs.fields)

        let started = requestManager.start(request, with: args, forGroupId: groupId, jsonLink: nil, externalCallback: nil)
        requestManager.addListener(listener, forRequest: request)
        return started
    }
}

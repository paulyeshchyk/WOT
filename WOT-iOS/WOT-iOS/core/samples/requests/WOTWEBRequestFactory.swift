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
        do {
            try requestManager?.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, onObjectDidFetch: nil)
        } catch let error {
            print(error)
        }
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
        args.setValues([Vehicles.classKeypaths()], forKey: WGWebQueryArgs.fields)

        requestManager.addListener(listener, forRequest: request)
        do {
            try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, onObjectDidFetch: nil)
        } catch let error {
            print(error)
        }
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

        do {
            try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, onObjectDidFetch: nil)
            requestManager.addListener(listener, forRequest: request)
        } catch let error {
            print(error)
        }
    }
}

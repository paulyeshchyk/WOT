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
    public static func fetchVehiclePivotData(_ requestManager: WOTRequestManagerProtocol?, listener: WOTRequestManagerListenerProtocol) throws {
        guard let requestManager = requestManager else {
            throw LogicError.objectNotDefined
        }
        let arguments = WOTRequestArguments()
        arguments.setValues(Vehicles.fieldsKeypaths(), forKey: WGWebQueryArgs.fields)

        let request = try requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue)
        requestManager.addListener(listener, forRequest: request)
        let pivotLinker = Vehicles.VehiclesPivotDataLinker(masterFetchResult: EmptyFetchResult(), mappedObjectIdentifier: nil)
        try requestManager.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonAdapterLinker: pivotLinker)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) throws {
        let arguments = WOTRequestArguments()
        arguments.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        arguments.setValues(Vehicles.classKeypaths(), forKey: WGWebQueryArgs.fields)

        let request = try requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue)
        requestManager.addListener(listener, forRequest: request)
        let treeViewLinker = Vehicles.VehiclesTreeViewLinker(masterFetchResult: EmptyFetchResult(), mappedObjectIdentifier: nil)
        try requestManager.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonAdapterLinker: treeViewLinker)
    }

    @objc
    public static func fetchProfileData(profileTankId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) throws {
//        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue)
//        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"
//
//        let args = WOTRequestArguments()
//        args.setValues([profileTankId], forKey: WOTApiKeys.tank_id)
//        args.setValues([Vehicleprofile.fieldsKeypaths()], forKey: WGWebQueryArgs.fields)

//        fatalError("not implemented")
//        try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, linker: nil)
//        requestManager.addListener(listener, forRequest: request)
    }
}

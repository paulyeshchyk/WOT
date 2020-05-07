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
        let coreDataStore = requestManager.appManager?.coreDataStore
        let pivotLinker = Vehicles.VehiclesPivotDataLinker(masterFetchResult: EmptyFetchResult(), mappedObjectIdentifier: nil, coreDataStore: coreDataStore)
        try requestManager.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, linker: pivotLinker)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) throws {
        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue)

        let args = WOTRequestArguments()
        args.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicles.classKeypaths()], forKey: WGWebQueryArgs.fields)

        requestManager.addListener(listener, forRequest: request)

        let coreDataStore = requestManager.appManager?.coreDataStore
        let predicate = NSPredicate(format: "%K == %d", "tank_id", vehicleId)
        if let context = coreDataStore?.mainContext {
            coreDataStore?.findOrCreateObject(by: Vehicles.self, andPredicate: predicate, visibleInContext: context, callback: { fetchResult, error in
                if let error = error {
                    coreDataStore?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }

                let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"
                let modulesTreeHelper: JSONAdapterLinkerProtocol = Vehicles.VehiclesModulesTreeLinker(masterFetchResult: fetchResult, mappedObjectIdentifier: nil, coreDataStore: coreDataStore)
                try? requestManager.startRequest(request, withArguments: args, forGroupId: groupId, linker: modulesTreeHelper)
            })
        }
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

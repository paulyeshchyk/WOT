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
        do {
            try requestManager.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, instanceHelper: nil)
        } catch let error {
            print(error)
        }
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) throws {
        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.vehicles.rawValue)
        let groupId = "WOT_REQUEST_ID_VEHICLE_BY_TIER:\(vehicleId)"

        let args = WOTRequestArguments()
        args.setValues([vehicleId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicles.classKeypaths()], forKey: WGWebQueryArgs.fields)

        requestManager.addListener(listener, forRequest: request)

        let provider = requestManager.appManager?.coreDataStore
        let persistentStore = requestManager.appManager?.mappingCoordinator
        let predicate = NSPredicate(format: "%K == %d", "tank_id", vehicleId)
        if let context = provider?.mainContext {
            provider?.findOrCreateObject(by: Vehicles.self, andPredicate: predicate, visibleInContext: context, callback: { fetchResult in
                let modulesTreeHelper: JSONAdapterInstanceHelper? = nil //Vehicles.TreeJSONAdapterHelper(objectID: fetchResult.managedObject().objectID, identifier: nil, persistentStore: persistentStore)
                try? requestManager.startRequest(request, withArguments: args, forGroupId: groupId, instanceHelper: modulesTreeHelper)
            })
//            provider?.findOrCreateObject(by: Vehicles.self, andPredicate: predicate, visibleInContext: context) { (fetchResult) in
//            }
        }
    }

    @objc
    public static func fetchProfileData(profileTankId: Int, requestManager: WOTRequestManagerProtocol, listener: WOTRequestManagerListenerProtocol) throws {
        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue)
        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"

        let args = WOTRequestArguments()
        args.setValues([profileTankId], forKey: WOTApiKeys.tank_id)
        args.setValues([Vehicleprofile.fieldsKeypaths()], forKey: WGWebQueryArgs.fields)

        try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, instanceHelper: nil)
        requestManager.addListener(listener, forRequest: request)
    }
}

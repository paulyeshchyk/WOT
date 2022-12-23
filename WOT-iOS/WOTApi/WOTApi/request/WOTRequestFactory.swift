//
//  WOTRequestFactory.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK
import WOTKit

@objc
public class WOTWEBRequestFactory: NSObject {
    
    private enum HttpRequestFactoryError: Error {
        case objectNotDefined
    }
    
    public static func fetchVehiclePivotData(inContext context: RequestRegistratorContainerProtocol & RequestManagerContainerProtocol, listener: RequestManagerListenerProtocol) throws {
        let arguments = RequestArguments()
        arguments.setValues(Vehicles.fieldsKeypaths(), forKey: WGWebQueryArgs.fields)

        guard let request = try context.requestRegistrator?.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else {
            throw HttpRequestFactoryError.objectNotDefined
        }
        let pivotLinker = Vehicles.VehiclesPivotDataLinker(masterFetchResult: EmptyFetchResult(), mappedObjectIdentifier: nil)
        try context.requestManager?.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonAdapterLinker: pivotLinker, listener: listener)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, inContext context: RequestRegistratorContainerProtocol & RequestManagerContainerProtocol, listener: RequestManagerListenerProtocol) throws {
        let arguments = RequestArguments()
        arguments.setValues([vehicleId], forKey: WOTApiFields.tank_id)
        arguments.setValues(Vehicles.classKeypaths(), forKey: WGWebQueryArgs.fields)

        guard let request = try context.requestRegistrator?.createRequest(forRequestId: WebRequestType.vehicles.rawValue) else {
            throw HttpRequestFactoryError.objectNotDefined
        }
        let treeViewLinker = Vehicles.VehiclesTreeViewLinker(masterFetchResult: EmptyFetchResult(), mappedObjectIdentifier: nil)
        try context.requestManager?.startRequest(request, withArguments: arguments, forGroupId: WGWebRequestGroups.vehicle_list, jsonAdapterLinker: treeViewLinker, listener: listener)
    }

    @objc
    public static func fetchProfileData(profileTankId: Int, requestManager: RequestManagerProtocol, listener: RequestManagerListenerProtocol) throws {
//        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue)
//        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"
//
//        let args = WOTRequestArguments()
//        args.setValues([profileTankId], forKey: WOTApiFields.tank_id)
//        args.setValues([Vehicleprofile.fieldsKeypaths()], forKey: WGWebQueryArgs.fields)

//        fatalError("not implemented")
//        try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, linker: nil)
//        requestManager.addListener(listener, forRequest: request)
    }
}

//
//  WOTRequestFactory.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

// MARK: - WOTWEBRequestFactory

@objc
public class WOTWEBRequestFactory: NSObject {
    //
    public typealias Context = DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol

    private enum HttpRequestFactoryError: Error, CustomStringConvertible {
        case objectNotDefined

        public var description: String {
            switch self {
            case .objectNotDefined: return "[\(type(of: self))]: Object not defined"
            }
        }
    }

    // MARK: Public

    public static func fetchVehiclePivotData(appContext: WOTWEBRequestFactory.Context, listener: RequestManagerListenerProtocol) throws {
        guard let request = try appContext.requestManager?.createRequest(modelClass: Vehicles.self, contextPredicate: nil) else {
            throw HttpRequestFactoryError.objectNotDefined
        }

        let extractor = VehiclesPivotManagedObjectExtractor()
        let linker = ManagedObjectLinker(modelClass: Vehicles.self)
        try appContext.requestManager?.startRequest(request, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: listener)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, appContext: DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol, listener: RequestManagerListenerProtocol) throws {
        let modelClass = Vehicles.self
        let contextPredicate = ContextPredicate()
        contextPredicate[.primary] = modelClass.primaryKey(forType: .internal, andObject: vehicleId)

        guard let request = try appContext.requestManager?.createRequest(modelClass: modelClass, contextPredicate: contextPredicate) else {
            throw HttpRequestFactoryError.objectNotDefined
        }
        let extractor = VehiclesTreeManagedObjectExtractor()
        let managedObjectLinker = ManagedObjectLinker(modelClass: Vehicles.self)

        try appContext.requestManager?.startRequest(request, managedObjectLinker: managedObjectLinker, managedObjectExtractor: extractor, listener: listener)
    }

    @objc
    public static func fetchProfileData(profileTankId _: Int, requestManager _: RequestManagerProtocol, listener _: RequestManagerListenerProtocol) throws {
//        let request: WOTRequestProtocol = try requestManager.createRequest(forRequestId: WebRequestType.tankProfile.rawValue)
//        let groupId = "\(WGWebRequestGroups.vehicle_profile):\(profileTankId)"
//
//        let args = WOTRequestArguments()
//        args.setValues([profileTankId], forKey: WOTApiFields.tank_id)
//        args.setValues([Vehicleprofile.fieldsKeypaths()], forKey: WGWebQueryArgs.fields)

//        fatalError("not implemented")
//        appContext.logInspector?.logEvent(EventFlowStart(request), sender: self)
//        try requestManager.startRequest(request, withArguments: args, forGroupId: groupId, linker: nil)
//        requestManager.addListener(listener, forRequest: request)
    }
}

extension WOTWEBRequestFactory {

    private class VehiclesPivotManagedObjectExtractor: ManagedObjectExtractable {

        public var linkerPrimaryKeyType: PrimaryKeyType {
            return .internal
        }

        public var jsonKeyPath: KeypathType? {
            nil
        }
    }

    private class VehiclesTreeManagedObjectExtractor: ManagedObjectExtractable {

        public var linkerPrimaryKeyType: PrimaryKeyType {
            return .internal
        }

        public var jsonKeyPath: KeypathType? {
            nil
        }
    }
}

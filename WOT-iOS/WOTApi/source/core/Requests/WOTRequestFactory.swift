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
    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestRegistratorContainerProtocol
        & RequestManagerContainerProtocol
        & DecoderManagerContainerProtocol

    private enum HttpRequestFactoryError: Error, CustomStringConvertible {
        case objectNotDefined

        public var description: String {
            switch self {
            case .objectNotDefined: return "[\(type(of: self))]: Object not defined"
            }
        }
    }

    // MARK: Public

    public static func fetchVehiclePivotData(appContext: Context, listener: RequestManagerListenerProtocol) throws {
        //
        let modelClass = Vehicles.self

        let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(appContext: appContext)
        httpJSONResponseConfiguration.socket = nil
        httpJSONResponseConfiguration.extractor = VehiclesPivotManagedObjectExtractor()

        let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
        httpRequestConfiguration.modelFieldKeyPaths = modelClass.dataFieldsKeypaths()
        httpRequestConfiguration.composer = nil

        guard let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration) else {
            throw HttpRequestFactoryError.objectNotDefined
        }

        try appContext.requestManager?.startRequest(request, listener: listener)
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, appContext: Context, listener: RequestManagerListenerProtocol) throws {
        //
        let modelClass = Vehicles.self

        let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(appContext: appContext)
        httpJSONResponseConfiguration.socket = nil
        httpJSONResponseConfiguration.extractor = VehiclesTreeManagedObjectExtractor()

        let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
        httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
        httpRequestConfiguration.composer = VehicleTreeRuleBuilder(modelClass: modelClass, vehicleId: vehicleId)

        guard let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration) else {
            throw HttpRequestFactoryError.objectNotDefined
        }
        try appContext.requestManager?.startRequest(request, listener: listener)
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

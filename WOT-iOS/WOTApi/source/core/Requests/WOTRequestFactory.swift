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
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    private enum HttpRequestFactoryError: Error, CustomStringConvertible {
        case objectNotDefined

        public var description: String {
            switch self {
            case .objectNotDefined: return "[\(type(of: self))]: Object not defined"
            }
        }
    }

    // MARK: Public

    public static func fetchVehiclePivotData(appContext: Context, completion: @escaping ListenerCompletionType) throws {
        //
        let modelClass = Vehicles.self
        let modelFieldKeyPaths = modelClass.dataFieldsKeypaths()// modelClass.dataFieldsKeypaths()// modelClass.fieldsKeypaths()

        let uow = UOWRemote(appContext: appContext)
        uow.modelClass = modelClass
        uow.modelFieldKeyPaths = modelFieldKeyPaths
        uow.socket = nil
        uow.extractor = VehiclesPivotManagedObjectExtractor()
        uow.contextPredicate = nil
        uow.nextDepthLevel = DecodingDepthLevel.initial(maxLevel: 0)
        appContext.uowManager.run(unit: uow) { result in
            completion(result)
        }
    }

    @objc
    public static func fetchVehicleTreeData(vehicleId: Int, appContext: Context, completion: @escaping ListenerCompletionType) {
        //
        let modelClass = Vehicles.self
        let modelFieldKeyPaths = modelClass.fieldsKeypaths()

        let composer = VehicleTreeRuleBuilder(modelClass: modelClass, vehicleId: vehicleId)
        let contextPredicate = try? composer.buildRequestPredicateComposition()

        let uow = UOWRemote(appContext: appContext)
        uow.modelClass = modelClass
        uow.modelFieldKeyPaths = modelFieldKeyPaths
        uow.socket = nil
        uow.extractor = VehiclesTreeManagedObjectExtractor()
        uow.contextPredicate = contextPredicate
        uow.nextDepthLevel = DecodingDepthLevel.initial()
        appContext.uowManager.run(unit: uow) { result in
            completion(result)
        }
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

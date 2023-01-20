//
//  VehicleprofileArmorListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileArmorListJSONDecoder

class VehicleprofileArmorListJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let armorListJSON = try map.data(ofType: JSON.self)

        // MARK: - turret

        let keypathturret = #keyPath(VehicleprofileArmorList.turret)
        if let jsonElement = armorListJSON?[keypathturret] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: composition.objectIdentifier, keypath: keypathturret)
            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            let config = UoW_Config__Fetch_Decode_Link()
            config.appContext = appContext
            config.jsonMaps = [jsonMap]
            config.modelClass = modelClass
            config.socket = socket
            config.decodingDepthLevel = decodingDepthLevel
            let uow = try appContext.uowManager.uow(by: config)
            try appContext.uowManager.perform(uow: uow)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleProfileArmorListError.turretNotFound), sender: self)
        }

        // MARK: - hull

        let keypathhull = #keyPath(VehicleprofileArmorList.hull)
        if let jsonElement = armorListJSON?[keypathhull] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: composition.objectIdentifier, keypath: keypathhull)

            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            let config = UoW_Config__Fetch_Decode_Link()
            config.appContext = appContext
            config.jsonMaps = [jsonMap]
            config.modelClass = modelClass
            config.socket = socket
            config.decodingDepthLevel = decodingDepthLevel
            let uow = try appContext.uowManager.uow(by: config)
            try appContext.uowManager.perform(uow: uow)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleProfileArmorListError.hullNotFound), sender: self)
        }
    }
}

extension VehicleprofileArmorList {

    private class HullExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}

// MARK: - VehicleProfileArmorListError

private enum VehicleProfileArmorListError: Error, CustomStringConvertible {
    case hullNotFound
    case turretNotFound

    var description: String {
        switch self {
        case .turretNotFound: return "[\(type(of: self))]: Turret not found"
        case .hullNotFound: return "[\(type(of: self))]: Hull not found"
        }
    }
}

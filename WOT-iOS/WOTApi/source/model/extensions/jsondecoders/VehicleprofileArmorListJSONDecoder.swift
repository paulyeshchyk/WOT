//
//  VehicleprofileArmorListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileArmorListJSONDecoder

class VehicleprofileArmorListJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let armorListJSON = try map.data(ofType: JSON.self)
        // ??? try managedObject.decode(decoderContainer: armorListJSON)

        // MARK: - turret

        let keypathturret = #keyPath(VehicleprofileArmorList.turret)
        if let jsonElement = armorListJSON?[keypathturret] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: keypathturret)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    self.appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileArmorListError.turretNotFound), sender: self)
        }

        // MARK: - hull

        let keypathhull = #keyPath(VehicleprofileArmorList.hull)
        if let jsonElement = armorListJSON?[keypathhull] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: keypathhull)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    self.appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileArmorListError.hullNotFound), sender: self)
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

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

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileArmorListJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

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

            let uow = UOWDecodeAndLinkMaps()
            uow.appContext = appContext
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            try appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileArmorListJSONDecoderErrors.turretNotFound), sender: self)
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

            let uow = UOWDecodeAndLinkMaps()
            uow.appContext = appContext
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            try appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileArmorListJSONDecoderErrors.hullNotFound), sender: self)
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

// MARK: - VehicleprofileArmorListJSONDecoder.VehicleprofileArmorListJSONDecoderErrors

extension VehicleprofileArmorListJSONDecoder {

    enum VehicleprofileArmorListJSONDecoderErrors: Error, CustomStringConvertible {
        case hullNotFound
        case turretNotFound
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        var description: String {
            switch self {
            case .turretNotFound: return "[\(type(of: self))]: Turret not found"
            case .hullNotFound: return "[\(type(of: self))]: Hull not found"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}

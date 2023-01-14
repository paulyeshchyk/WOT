//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmorList {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let armorListJSON = try map.data(ofType: JSON.self)
        let vehicleprofileArmorListFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - turret

        let keypathturret = #keyPath(VehicleprofileArmorList.turret)
        if let jsonElement = armorListJSON?[keypathturret] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), managedRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(identifier: composition.objectIdentifier, keypath: keypathturret)
            let linker = ManagedObjectLinker(modelClass: modelClass, managedRef: vehicleprofileArmorListFetchResult, socket: socket)
            let extractor = TurretExtractor()
            let objectContext = vehicleprofileArmorListFetchResult.managedObjectContext
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            MOSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileArmorListError.turretNotFound), sender: self)
        }

        // MARK: - hull

        let keypathhull = #keyPath(VehicleprofileArmorList.hull)
        if let jsonElement = armorListJSON?[keypathhull] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), managedRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(identifier: composition.objectIdentifier, keypath: keypathhull)
            let linker = ManagedObjectLinker(modelClass: modelClass, managedRef: vehicleprofileArmorListFetchResult, socket: socket)
            let extractor = HullExtractor()
            let objectContext = vehicleprofileArmorListFetchResult.managedObjectContext
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            MOSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
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

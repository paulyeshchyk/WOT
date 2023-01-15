//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmorList {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer _: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let armorListJSON = try map.data(ofType: JSON.self)

        // MARK: - turret

        let keypathturret = #keyPath(VehicleprofileArmorList.turret)
        if let jsonElement = armorListJSON?[keypathturret] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: foreignSelectKey, managedRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier, keypath: keypathturret)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, completion: { _, error in
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
            let foreignSelectKey = #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull)
            let modelClass = VehicleprofileArmor.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: foreignSelectKey, managedRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier, keypath: keypathhull)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, completion: { _, error in
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

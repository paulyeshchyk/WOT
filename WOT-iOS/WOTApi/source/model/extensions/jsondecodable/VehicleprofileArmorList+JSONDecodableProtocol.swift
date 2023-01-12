//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmorList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        guard let armorListJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        let vehicleprofileArmorListFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - turret

        let keypathturret = #keyPath(VehicleprofileArmorList.turret)
        if let jsonElement = armorListJSON[keypathturret] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let collection = try JSONCollection(element: jsonElement)
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(identifier: composition.objectIdentifier, keypath: keypathturret)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileArmorListFetchResult, socket: socket)
            let extractor = TurretExtractor()
            let objectContext = vehicleprofileArmorListFetchResult.managedObjectContext
            MOSyndicate.decodeAndLink(appContext: appContext, jsonCollection: collection, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, contextPredicate: composition.contextPredicate, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileArmorListError.turretNotFound), sender: self)
        }

        // MARK: - hull

        let keypathhull = #keyPath(VehicleprofileArmorList.hull)
        if let jsonElement = armorListJSON[keypathhull] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let collection = try JSONCollection(element: jsonElement)
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(identifier: composition.objectIdentifier, keypath: keypathhull)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileArmorListFetchResult, socket: socket)
            let extractor = HullExtractor()
            let objectContext = vehicleprofileArmorListFetchResult.managedObjectContext
            MOSyndicate.decodeAndLink(appContext: appContext, jsonCollection: collection, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, contextPredicate: composition.contextPredicate, completion: { _, error in
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
//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoList {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let profilesJSON = try map.data(ofType: [JSON].self)
        //
        let keypath = #keyPath(VehicleprofileAmmo.type)
        try profilesJSON?.forEach { jsonElement in
            let foreignSelectKey = #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList)
            let ammoType = jsonElement[keypath]
            let modelClass = VehicleprofileAmmo.self
            let pin = JointPin(modelClass: modelClass, identifier: ammoType, contextPredicate: map.contextPredicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(pin: pin, foreignSelectKey: foreignSelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let managedObjectContext = managedObjectContextContainer.managedObjectContext
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            MOSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, managedObjectContext: managedObjectContext, modelClass: modelClass, managedObjectLinker: managedObjectLinker, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        }
    }
}

// MARK: - VehicleprofileAmmoList.AmmoExtractor

extension VehicleprofileAmmoList {

    private class AmmoExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}

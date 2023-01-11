//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        guard let profilesJSON = map.jsonCollection.data() as? [JSON] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }

        let vehicleprofileAmmoListFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        let keypath = #keyPath(VehicleprofileAmmo.type)
        for jsonElement in profilesJSON {
            let ammoType = jsonElement[keypath]
            let modelClass = VehicleprofileAmmo.self
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: ammoType, contextPredicate: map.contextPredicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(pin: pin, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = ManagedObjectLinkerSocket(identifier: composition.objectIdentifier)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileAmmoListFetchResult, socket: socket)
            let extractor = AmmoExtractor()
            let objectContext = vehicleprofileAmmoListFetchResult.managedObjectContext
            MOSyndicate.decodeAndLink(appContext: appContext, jsonCollection: collection, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, contextPredicate: composition.contextPredicate, completion: { _, error in
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

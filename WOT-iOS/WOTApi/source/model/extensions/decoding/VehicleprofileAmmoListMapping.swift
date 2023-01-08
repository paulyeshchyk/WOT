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
            let joint = Joint(modelClass: modelClass, theID: ammoType, contextPredicate: map.contextPredicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(drivenJoint: joint, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileAmmoListFetchResult, anchor: anchor)
            let extractor = VehicleprofileAmmoListAmmoManagedObjectCreator()
            let objectContext = vehicleprofileAmmoListFetchResult.managedObjectContext
            ModuleSyndicate.decodeAndLink(appContext: appContext, jsonCollection: collection, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, contextPredicate: composition.contextPredicate, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        }
    }
}

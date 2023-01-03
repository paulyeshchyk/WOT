//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profilesJSON = map.jsonCollection.data() as? [JSON] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }

        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        let keypath = #keyPath(VehicleprofileAmmo.type)
        for jsonElement in profilesJSON {
            let ammoType = jsonElement[keypath]
            let modelClass = VehicleprofileAmmo.self
            let joint = Joint(modelClass: modelClass, theID: ammoType, thePredicate: map.predicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(drivenJoint: joint, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let extractor = VehicleprofileAmmoListAmmoManagedObjectCreator()
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition, appContext: appContext)
        }
    }
}

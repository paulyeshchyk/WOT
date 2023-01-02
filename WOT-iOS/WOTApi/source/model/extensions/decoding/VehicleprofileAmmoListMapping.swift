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

        for jsonElement in profilesJSON {
            let ammoType = jsonElement[#keyPath(VehicleprofileAmmo.type)]
            let modelClass = VehicleprofileAmmo.self
            let joint = Joint(theClass: modelClass, theID: ammoType, thePredicate: map.predicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(drivenJoint: joint, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileAmmoListAmmoManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        }
    }
}

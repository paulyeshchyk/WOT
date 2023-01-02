//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profilesJSON = map.jsonCollection.data() as? [JSON] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }

        let vehicleProfileAmmoListFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        for profile in profilesJSON {
            let ammoType = profile[#keyPath(VehicleprofileAmmo.type)]
            let ammoJoint = Joint(theClass: VehicleprofileAmmo.self, theID: ammoType, thePredicate: map.predicate)
            let ruleBuilder = VehicleprofileAmmoListAmmoRequestPredicateComposer(drivenJoint: ammoJoint, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let ammoLinkerClass = VehicleprofileAmmoListAmmoManagedObjectCreator.self
            let jsonCollection = try JSONCollection(element: profile)
            let composition = try ruleBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: jsonCollection, masterFetchResult: vehicleProfileAmmoListFetchResult, linkedClazz: VehicleprofileAmmo.self, managedObjectCreatorClass: ammoLinkerClass, requestPredicateComposition: composition, appContext: appContext)
        }
    }
}

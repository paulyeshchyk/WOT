//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profilesJSON = map.mappingData as? [JSON] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }

        let vehicleProfileAmmoListFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        for profile in profilesJSON {
            let ammoType = profile[#keyPath(VehicleprofileAmmo.type)] as AnyObject
            let ruleBuilder = VehicleprofileAmmoListAmmoRequestPredicateComposer(requestPredicate: map.predicate, ammoType: ammoType, linkedClazz: VehicleprofileAmmo.self, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let ammoLinkerClass = VehicleprofileAmmoListAmmoManagedObjectCreator.self
            let jsonCollection = try JSONCollection(element: profile)
            let composition = try ruleBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: jsonCollection, masterFetchResult: vehicleProfileAmmoListFetchResult, linkedClazz: VehicleprofileAmmo.self, managedObjectCreatorClass: ammoLinkerClass, requestPredicateComposition: composition, appContext: appContext)
        }
    }
}

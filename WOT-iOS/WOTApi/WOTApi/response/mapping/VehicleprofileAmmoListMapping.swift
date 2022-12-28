//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoList {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let profiles = map.mappingData as? [JSON] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }

        let vehicleProfileAmmoListFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        for profile in profiles {
            let ammoType = profile[#keyPath(VehicleprofileAmmo.type)] as AnyObject
            let ruleBuilder = ForeignAsPrimaryLinkedAsSecondaryRuleBuilder(requestPredicate: map.predicate, ammoType: ammoType, linkedClazz: VehicleprofileAmmo.self, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let ammoLinkerClass = VehicleprofileAmmoListAmmoManagedObjectCreator.self

            let jsonCollection = try JSONCollection(element: profile)
            inContext.mappingCoordinator?.linkItem(from: jsonCollection, masterFetchResult: vehicleProfileAmmoListFetchResult, linkedClazz: VehicleprofileAmmo.self, managedObjectCreatorClass: ammoLinkerClass, lookupRuleBuilder: ruleBuilder, appContext: inContext)
        }
    }
}

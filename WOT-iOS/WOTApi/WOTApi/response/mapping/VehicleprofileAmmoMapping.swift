//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmo {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let ammo = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: ammo)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - Penetration

        let penetrationArray = ammo[#keyPath(VehicleprofileAmmo.penetration)]
        let penetrationMapper = VehicleprofileAmmoPenetrationManagedObjectCreator.self
        let penetrationRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        let penetrationListCollection = JSONCollection(custom: penetrationArray)
        inContext.mappingCoordinator?.linkItem(from: penetrationListCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoPenetration.self, managedObjectCreatorClass: penetrationMapper, lookupRuleBuilder: penetrationRuleBuilder, appContext: inContext)

        // MARK: - Damage

        let damageArray = ammo[#keyPath(VehicleprofileAmmo.damage)]
        let damageMapper = VehicleprofileAmmoDamageManagedObjectCreator.self
        let damageRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))

        let damageListCollection = JSONCollection(custom: damageArray)
        inContext.mappingCoordinator?.linkItem(from: damageListCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoDamage.self, managedObjectCreatorClass: damageMapper, lookupRuleBuilder: damageRuleBuilder, appContext: inContext)
    }
}

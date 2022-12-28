//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmo {
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
        let penetrationMapper = VehicleprofileAmmo.VehicleprofileAmmoPenetrationManagedObjectCreator.self
        let penetrationRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        let penetrationListCollection = JSONCollection(custom: penetrationArray)
        inContext.mappingCoordinator?.linkItem(from: penetrationListCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoPenetration.self, managedObjectCreatorClass: penetrationMapper, lookupRuleBuilder: penetrationRuleBuilder, appContext: inContext)

        // MARK: - Damage

        let damageArray = ammo[#keyPath(VehicleprofileAmmo.damage)]
        let damageMapper = VehicleprofileAmmo.VehicleprofileAmmoDamageManagedObjectCreator.self
        let damageRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))

        let damageListCollection = JSONCollection(custom: damageArray)
        inContext.mappingCoordinator?.linkItem(from: damageListCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoDamage.self, managedObjectCreatorClass: damageMapper, lookupRuleBuilder: damageRuleBuilder, appContext: inContext)
    }
}

extension VehicleprofileAmmo {
    public class VehicleprofileAmmoPenetrationManagedObjectCreator: ManagedObjectCreator {
        //
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? {
            return json
        }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let managedObjectContext = fetchResult.managedObjectContext else {
                assertionFailure("Managed object context is not defined")
                return
            }
            guard let penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoPenetration.self))
                return
            }
            guard let ammo = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileAmmo else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
                return
            }

            ammo.penetration = penetration
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehicleprofileAmmoDamageManagedObjectCreator: ManagedObjectCreator {
        //
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? {
            return json
        }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let objectContext = fetchResult.managedObjectContext
            guard let damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoDamage.self))
                return
            }
            guard let ammo = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? VehicleprofileAmmo else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
                return
            }
            ammo.damage = damage

            dataStore?.stash(objectContext: objectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}

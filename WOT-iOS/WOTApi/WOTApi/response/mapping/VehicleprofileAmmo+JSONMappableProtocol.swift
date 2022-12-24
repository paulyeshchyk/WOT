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
    override public func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, inContext: JSONMappableProtocol.Context) throws {
        //
        try self.decode(json: json)
        //

        let masterFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - Penetration

        let penetrationArray = json[#keyPath(VehicleprofileAmmo.penetration)] as? [Any]
        let penetrationMapper = VehicleprofileAmmo.PenetrationLinker.self
        let penetrationRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: requestPredicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        inContext.mappingCoordinator?.linkItems(from: penetrationArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoPenetration.self, mapperClazz: penetrationMapper, lookupRuleBuilder: penetrationRuleBuilder, requestManager: inContext.requestManager)

        // MARK: - Damage

        let damageArray = json[#keyPath(VehicleprofileAmmo.damage)] as? [Any]
        let damageMapper = VehicleprofileAmmo.DamageLinker.self
        let damageRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: requestPredicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        inContext.mappingCoordinator?.linkItems(from: damageArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoDamage.self, mapperClazz: damageMapper, lookupRuleBuilder: damageRuleBuilder, requestManager: inContext.requestManager)
    }
}

extension VehicleprofileAmmo {
    public class PenetrationLinker: BaseJSONAdapterLinker {
        //
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let managedObjectContext = fetchResult.objectContext else {
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

    public class DamageLinker: BaseJSONAdapterLinker {
        //
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let objectContext = fetchResult.objectContext
            if let damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage {
                if let ammo = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? VehicleprofileAmmo {
                    ammo.damage = damage

                    dataStore?.stash(objectContext: objectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

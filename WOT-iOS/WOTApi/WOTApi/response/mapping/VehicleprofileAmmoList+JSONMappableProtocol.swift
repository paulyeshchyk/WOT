//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmoList {
    override public func mapping(arraymap: ArrayMapManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //

        let vehicleProfileAmmoListFetchResult = FetchResult(objectContext: arraymap.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)
        arraymap.array.compactMap { $0 as? JSON }.forEach { jSON in

            let ammoType = jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject
            let ruleBuilder = ForeignAsPrimaryLinkedAsSecondaryRuleBuilder(requestPredicate: arraymap.predicate, ammoType: ammoType, linkedClazz: VehicleprofileAmmo.self, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let ammoLinkerClass = VehicleprofileAmmoList.VehicleprofileAmmoListAmmoLinker.self
            inContext.mappingCoordinator?.linkItem(from: jSON, masterFetchResult: vehicleProfileAmmoListFetchResult, linkedClazz: VehicleprofileAmmo.self, mapperClazz: ammoLinkerClass, lookupRuleBuilder: ruleBuilder, requestManager: inContext.requestManager)
        }
    }
}

extension VehicleprofileAmmoList {
    public class VehicleprofileAmmoListAmmoLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let ammo = fetchResult.managedObject() as? VehicleprofileAmmo else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
                return
            }
            guard let ammoList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileAmmoList else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
                return
            }
            ammoList.addToVehicleprofileAmmo(ammo)
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}

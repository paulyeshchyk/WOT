//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmoList {
    override public func mapping(array: [Any], context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //

        let vehicleProfileAmmoListFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)
        array.compactMap { $0 as? JSON }.forEach { jSON in

            let ammoType = jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject
            let ruleBuilder = ForeignAsPrimaryLinkedAsSecondaryRuleBuilder(pkCase: pkCase, ammoType: ammoType, linkedClazz: VehicleprofileAmmo.self, foreignSelectKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            let ammoLinkerClass = VehicleprofileAmmoList.VehicleprofileAmmoListAmmoLinker.self
            mappingCoordinator?.linkItem(from: jSON, masterFetchResult: vehicleProfileAmmoListFetchResult, linkedClazz: VehicleprofileAmmo.self, mapperClazz: ammoLinkerClass, lookupRuleBuilder: ruleBuilder)
        }
    }
}

extension VehicleprofileAmmoList {
    public class VehicleprofileAmmoListAmmoLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let ammo = fetchResult.managedObject() as? VehicleprofileAmmo {
                if let ammoList = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileAmmoList {
                    ammoList.addToVehicleprofileAmmo(ammo)

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

//
//  VehicleprofileAmmoList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmoList {
    public override func mapping(array: [Any], context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject, andType: .internal)

            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileAmmo.self, pkCase: vehicleprofileAmmoCase) { fetchResult, error in

                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }

                let ammoLinker: JSONAdapterLinkerProtocol? = VehicleprofileAmmoList.VehicleprofileAmmoListAmmoLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.decodingAndMapping(json: jSON, fetchResult: fetchResult, pkCase: vehicleprofileAmmoCase, linker: ammoLinker) { _, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        return
                    }

                    if let ammo = fetchResult.managedObject() as? VehicleprofileAmmo {
                        self.addToVehicleprofileAmmo(ammo)
                    }
                    mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        }
                    }
                }
            }
        }
    }
}

extension VehicleprofileAmmoList {
    public class VehicleprofileAmmoListAmmoLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let ammo = fetchResult.managedObject() as? VehicleprofileAmmo {
                if let ammoList = context.object(with: objectID) as? VehicleprofileAmmoList {
                    ammoList.addToVehicleprofileAmmo(ammo)

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

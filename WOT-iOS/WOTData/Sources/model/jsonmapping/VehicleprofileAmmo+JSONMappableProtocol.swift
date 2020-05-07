//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmo {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        if let penetrationArray = json[#keyPath(VehicleprofileAmmo.penetration)] as? [Any] {
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoPenetration.self, pkCase: vehicleprofileAmmoPenetrationCase) { fetchResult, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }
                let penetrationHelper: JSONAdapterLinkerProtocol? = nil
                mappingCoordinator?.decodingAndMapping(array: penetrationArray, fetchResult: fetchResult, pkCase: vehicleprofileAmmoPenetrationCase, linker: penetrationHelper) { fetchResult, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        return
                    }

                    self.penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration
                    mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        }
                    }
                }
            }
        }
        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))

        if let damageArray = json[#keyPath(VehicleprofileAmmo.damage)] as? [Any] {
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoDamage.self, pkCase: vehicleprofileAmmoDamageCase) { fetchResult, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }

                let damageHelper: JSONAdapterLinkerProtocol? = nil
                mappingCoordinator?.decodingAndMapping(array: damageArray, fetchResult: fetchResult, pkCase: vehicleprofileAmmoDamageCase, linker: damageHelper) { fetchResult, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        return
                    }

                    self.damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage
                    mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        }
                    }
                }
            }
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let json = json, let entityDescription = context.entityDescription(forType: VehicleprofileAmmo.self) else {
            fatalError("Entity description not found [\(String(describing: VehicleprofileAmmo.self))]")
            return nil
        }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey
        let fetchResult = FetchResult(context: context, objectID: self.objectID, predicate: pkCase.compoundPredicate(), fetchStatus: .none)
        mappingCoordinator?.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, linker: nil) { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }
}

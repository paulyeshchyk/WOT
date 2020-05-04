//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileArmorList {
    @objc
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(context: context, fromJSON: json[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, mappingCoordinator: mappingCoordinator) { fetchResult in
            let context = fetchResult.context
            if let hull = fetchResult.managedObject() as? VehicleprofileArmor {
                self.hull = hull
                mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(context: context, fromJSON: json[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, mappingCoordinator: mappingCoordinator) { fetchResult in
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileArmor {
                self.turret = turret
                mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
}

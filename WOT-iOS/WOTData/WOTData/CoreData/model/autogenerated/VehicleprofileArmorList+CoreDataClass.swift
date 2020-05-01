//
//  VehicleprofileArmorList+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData
import Foundation

@objc(VehicleprofileArmorList)
public class VehicleprofileArmorList: NSManagedObject {}

// MARK: - Mapping

extension VehicleprofileArmorList {
    @objc
    override public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { fetchResult in
            let context = fetchResult.context
            if let hull = fetchResult.managedObject() as? VehicleprofileArmor {
                self.hull = hull
                persistentStore?.stash(context: context, hint: hullCase) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { fetchResult in
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileArmor {
                self.turret = turret
                persistentStore?.stash(context: context, hint: hullCase) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
}

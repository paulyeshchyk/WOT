//
//  VehicleprofileArmorList+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileArmorList)
public class VehicleprofileArmorList: NSManagedObject {}

// MARK: - Mapping
extension VehicleprofileArmorList {
    @objc
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { context, managedObjectID, _ in
            guard let managedObjectID = managedObjectID, let hull = context.object(with: managedObjectID) as? VehicleprofileArmor else {
                return
            }

            self.hull = hull
            persistentStore?.stash(context: context, hint: hullCase)
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { context, managedObjectID, _ in
            guard let managedObjectID = managedObjectID, let turret = context.object(with: managedObjectID) as? VehicleprofileArmor else {
                return
            }
            self.turret = turret
            persistentStore?.stash(context: context, hint: hullCase)
        }
    }
}

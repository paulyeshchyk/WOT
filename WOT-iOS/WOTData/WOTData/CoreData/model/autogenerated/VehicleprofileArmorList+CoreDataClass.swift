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
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        let hullCase = RemotePKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { newObject in
            self.hull = newObject as? VehicleprofileArmor
            persistentStore?.stash(hint: hullCase)
        }

        let turretCase = RemotePKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { newObject in
            self.turret = newObject as? VehicleprofileArmor
            persistentStore?.stash(hint: hullCase)
        }
    }
}

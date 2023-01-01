//
//  VehicleprofileAmmo+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileAmmo {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmo> {
        return NSFetchRequest<VehicleprofileAmmo>(entityName: "VehicleprofileAmmo")
    }

    @NSManaged var type: String?
    @NSManaged var damage: VehicleprofileAmmoDamage?
    @NSManaged var penetration: VehicleprofileAmmoPenetration?
    @NSManaged var vehicleprofileAmmoList: VehicleprofileAmmoList?
}

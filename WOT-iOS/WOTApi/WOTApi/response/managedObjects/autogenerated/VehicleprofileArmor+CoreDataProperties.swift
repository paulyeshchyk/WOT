//
//  VehicleprofileArmor+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileArmor {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileArmor> {
        return NSFetchRequest<VehicleprofileArmor>(entityName: "VehicleprofileArmor")
    }

    @NSManaged var front: NSDecimalNumber?
    @NSManaged var rear: NSDecimalNumber?
    @NSManaged var sides: NSDecimalNumber?
    @NSManaged var vehicleprofileArmorListHull: VehicleprofileArmorList?
    @NSManaged var vehicleprofileArmorListTurret: VehicleprofileArmorList?
}

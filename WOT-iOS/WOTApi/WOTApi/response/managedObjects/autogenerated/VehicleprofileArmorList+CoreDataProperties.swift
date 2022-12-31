//
//  VehicleprofileArmorList+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileArmorList {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileArmorList> {
        return NSFetchRequest<VehicleprofileArmorList>(entityName: "VehicleprofileArmorList")
    }

    @NSManaged var hull: VehicleprofileArmor?
    @NSManaged var turret: VehicleprofileArmor?
    @NSManaged var vehicleprofile: Vehicleprofile?
}

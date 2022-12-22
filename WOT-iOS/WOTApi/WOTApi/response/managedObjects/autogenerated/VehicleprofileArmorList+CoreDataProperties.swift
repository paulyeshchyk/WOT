//
//  VehicleprofileArmorList+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

extension VehicleprofileArmorList {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileArmorList> {
        return NSFetchRequest<VehicleprofileArmorList>(entityName: "VehicleprofileArmorList")
    }

    @NSManaged public var hull: VehicleprofileArmor?
    @NSManaged public var turret: VehicleprofileArmor?
    @NSManaged public var vehicleprofile: Vehicleprofile?
}

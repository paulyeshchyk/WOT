//
//  VehicleprofileArmorList+CoreDataProperties.swift
//
//
//  Created by Pavel Yeshchyk on 4/23/20.
//
//

import Foundation
import CoreData

extension VehicleprofileArmorList {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileArmorList> {
        return NSFetchRequest<VehicleprofileArmorList>(entityName: "VehicleprofileArmorList")
    }

    @NSManaged public var hull: VehicleprofileArmor?
    @NSManaged public var turret: VehicleprofileArmor?
    @NSManaged public var vehicleprofile: Vehicleprofile?
}

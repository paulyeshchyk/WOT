//
//  VehicleprofileArmor+CoreDataProperties.swift
//
//
//  Created by Pavel Yeshchyk on 4/23/20.
//
//

import Foundation
import CoreData

extension VehicleprofileArmor {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileArmor> {
        return NSFetchRequest<VehicleprofileArmor>(entityName: "VehicleprofileArmor")
    }

    @NSManaged public var front: NSDecimalNumber?
    @NSManaged public var rear: NSDecimalNumber?
    @NSManaged public var sides: NSDecimalNumber?
    @NSManaged public var vehicleprofileArmorListHull: VehicleprofileArmorList?
    @NSManaged public var vehicleprofileArmorListTurret: VehicleprofileArmorList?
}

//
//  VehicleprofileAmmoDamage+CoreDataProperties.swift
//
//
//  Created by Pavel Yeshchyk on 4/23/20.
//
//

import Foundation
import CoreData

extension VehicleprofileAmmoDamage {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmoDamage> {
        return NSFetchRequest<VehicleprofileAmmoDamage>(entityName: "VehicleprofileAmmoDamage")
    }

    @NSManaged public var avg_value: NSDecimalNumber?
    @NSManaged public var max_value: NSDecimalNumber?
    @NSManaged public var min_value: NSDecimalNumber?
    @NSManaged public var vehicleprofileAmmo: VehicleprofileAmmo?
}

//
//  VehicleprofileAmmoDamage+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

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
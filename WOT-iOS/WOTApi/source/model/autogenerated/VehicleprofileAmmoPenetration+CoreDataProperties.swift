//
//  VehicleprofileAmmoPenetration+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileAmmoPenetration {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmoPenetration> {
        return NSFetchRequest<VehicleprofileAmmoPenetration>(entityName: "VehicleprofileAmmoPenetration")
    }

    @NSManaged var avg_value: NSDecimalNumber?
    @NSManaged var max_value: NSDecimalNumber?
    @NSManaged var min_value: NSDecimalNumber?
    @NSManaged var vehicleprofileAmmo: VehicleprofileAmmo?
}

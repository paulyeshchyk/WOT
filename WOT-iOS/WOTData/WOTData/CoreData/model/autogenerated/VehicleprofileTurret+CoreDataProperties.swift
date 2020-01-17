//
//  VehicleprofileTurret+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension VehicleprofileTurret {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileTurret> {
        return NSFetchRequest<VehicleprofileTurret>(entityName: "VehicleprofileTurret")
    }

    @NSManaged public var view_range: NSDecimalNumber?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var traverse_right_arc: NSDecimalNumber?
    @NSManaged public var traverse_left_arc: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var hp: NSDecimalNumber?
    @NSManaged public var tankturrets: Tankturrets?
    @NSManaged public var vehicleprofile: Vehicleprofile?

}

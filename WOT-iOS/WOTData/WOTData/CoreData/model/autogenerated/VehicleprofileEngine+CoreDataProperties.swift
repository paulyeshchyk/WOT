//
//  VehicleprofileEngine+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension VehicleprofileEngine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileEngine> {
        return NSFetchRequest<VehicleprofileEngine>(entityName: "VehicleprofileEngine")
    }

    @NSManaged public var fire_chance: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var power: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var tankengine: Tankengines?
    @NSManaged public var vehicleprofile: Vehicleprofile?

}

//
//  VehicleprofileGun+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension VehicleprofileGun {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileGun> {
        return NSFetchRequest<VehicleprofileGun>(entityName: "VehicleprofileGun")
    }

    @NSManaged public var aim_time: NSDecimalNumber?
    @NSManaged public var caliber: NSDecimalNumber?
    @NSManaged public var dispersion: NSDecimalNumber?
    @NSManaged public var fire_rate: NSDecimalNumber?
    @NSManaged public var move_down_arc: NSDecimalNumber?
    @NSManaged public var move_up_arc: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var reload_time: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var tankgun: Tankguns?
    @NSManaged public var vehicleprofile: Vehicleprofile?

}

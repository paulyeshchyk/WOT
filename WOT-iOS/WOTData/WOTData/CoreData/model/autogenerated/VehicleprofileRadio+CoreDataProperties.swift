//
//  VehicleprofileRadio+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension VehicleprofileRadio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileRadio> {
        return NSFetchRequest<VehicleprofileRadio>(entityName: "VehicleprofileRadio")
    }

    @NSManaged public var name: String?
    @NSManaged public var signal_range: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var tankradio: Tankradios?
    @NSManaged public var vehicleprofile: Vehicleprofile?

}

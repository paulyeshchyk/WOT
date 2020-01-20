//
//  VehicleprofileSuspension+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension VehicleprofileSuspension {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileSuspension> {
        return NSFetchRequest<VehicleprofileSuspension>(entityName: "VehicleprofileSuspension")
    }

    @NSManaged public var load_limit: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var traverse_speed: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var tankchassis: Tankchassis?
    @NSManaged public var vehicleprofile: Vehicleprofile?

}

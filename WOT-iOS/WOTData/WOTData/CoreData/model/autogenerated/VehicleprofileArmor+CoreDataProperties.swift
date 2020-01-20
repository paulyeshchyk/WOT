//
//  VehicleprofileArmor+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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

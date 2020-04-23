//
//  VehicleprofileTurret+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension VehicleprofileTurret {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileTurret> {
        return NSFetchRequest<VehicleprofileTurret>(entityName: "VehicleprofileTurret")
    }

    @NSManaged public var hp: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var traverse_left_arc: NSDecimalNumber?
    @NSManaged public var traverse_right_arc: NSDecimalNumber?
    @NSManaged public var traverse_speed: NSDecimalNumber?
    @NSManaged public var turret_id: NSDecimalNumber?
    @NSManaged public var view_range: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleprofileModule: VehicleprofileModule?
}

// MARK: Generated accessors for vehicle
extension VehicleprofileTurret {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

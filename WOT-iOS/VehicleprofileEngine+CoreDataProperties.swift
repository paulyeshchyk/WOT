//
//  VehicleprofileEngine+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
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
    @NSManaged public var engine_id: NSDecimalNumber?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicle: NSSet?
}

// MARK: Generated accessors for vehicle
extension VehicleprofileEngine {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

//
//  VehicleprofileTurret+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

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
    @NSManaged public var modules: NSSet?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleprofileModule: Module?
}

// MARK: Generated accessors for modules
extension VehicleprofileTurret {
    @objc(addModulesObject:)
    @NSManaged public func addToModules(_ value: VehicleprofileModule)

    @objc(removeModulesObject:)
    @NSManaged public func removeFromModules(_ value: VehicleprofileModule)

    @objc(addModules:)
    @NSManaged public func addToModules(_ values: NSSet)

    @objc(removeModules:)
    @NSManaged public func removeFromModules(_ values: NSSet)
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

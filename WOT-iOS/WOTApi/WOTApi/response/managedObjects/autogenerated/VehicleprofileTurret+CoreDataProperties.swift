//
//  VehicleprofileTurret+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileTurret {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileTurret> {
        return NSFetchRequest<VehicleprofileTurret>(entityName: "VehicleprofileTurret")
    }

    @NSManaged var hp: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var tag: String?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var traverse_left_arc: NSDecimalNumber?
    @NSManaged var traverse_right_arc: NSDecimalNumber?
    @NSManaged var traverse_speed: NSDecimalNumber?
    @NSManaged var turret_id: NSDecimalNumber?
    @NSManaged var view_range: NSDecimalNumber?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var modules: NSSet?
    @NSManaged var vehicle: NSSet?
    @NSManaged var vehicleprofile: Vehicleprofile?
    @NSManaged var vehicleprofileModule: Module?
}

// MARK: Generated accessors for modules

public extension VehicleprofileTurret {
    @objc(addModulesObject:)
    @NSManaged func addToModules(_ value: VehicleprofileModule)

    @objc(removeModulesObject:)
    @NSManaged func removeFromModules(_ value: VehicleprofileModule)

    @objc(addModules:)
    @NSManaged func addToModules(_ values: NSSet)

    @objc(removeModules:)
    @NSManaged func removeFromModules(_ values: NSSet)
}

// MARK: Generated accessors for vehicle

public extension VehicleprofileTurret {
    @objc(addVehicleObject:)
    @NSManaged func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged func removeFromVehicle(_ values: NSSet)
}

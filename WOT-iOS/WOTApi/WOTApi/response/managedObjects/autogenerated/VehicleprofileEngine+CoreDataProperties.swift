//
//  VehicleprofileEngine+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileEngine {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileEngine> {
        return NSFetchRequest<VehicleprofileEngine>(entityName: "VehicleprofileEngine")
    }

    @NSManaged var engine_id: NSDecimalNumber?
    @NSManaged var fire_chance: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var power: NSDecimalNumber?
    @NSManaged var tag: String?
    @NSManaged var test: String?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var modules: NSSet?
    @NSManaged var vehicle: NSSet?
    @NSManaged var vehicleprofile: Vehicleprofile?
    @NSManaged var vehicleprofileModule: Module?
}

// MARK: Generated accessors for modules

public extension VehicleprofileEngine {
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

public extension VehicleprofileEngine {
    @objc(addVehicleObject:)
    @NSManaged func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged func removeFromVehicle(_ values: NSSet)
}

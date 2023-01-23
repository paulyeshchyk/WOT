//
//  VehicleprofileGun+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileGun {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileGun> {
        return NSFetchRequest<VehicleprofileGun>(entityName: "VehicleprofileGun")
    }

    @NSManaged var aim_time: NSDecimalNumber?
    @NSManaged var caliber: NSDecimalNumber?
    @NSManaged var dispersion: NSDecimalNumber?
    @NSManaged var fire_rate: NSDecimalNumber?
    @NSManaged var gun_id: NSDecimalNumber?
    @NSManaged var move_down_arc: NSDecimalNumber?
    @NSManaged var move_up_arc: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var reload_time: NSDecimalNumber?
    @NSManaged var tag: String?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var modules: NSSet?
    @NSManaged var vehicle: NSSet?
    @NSManaged var vehicleprofile: NSSet?
    @NSManaged var vehicleprofileModule: Module?
}

// MARK: Generated accessors for modules

public extension VehicleprofileGun {
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

public extension VehicleprofileGun {
    @objc(addVehicleObject:)
    @NSManaged func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged func removeFromVehicle(_ values: NSSet)
}

// MARK: Generated accessors for vehicleprofile

public extension VehicleprofileGun {
    @objc(addVehicleprofileObject:)
    @NSManaged func addToVehicleprofile(_ value: Vehicleprofile)

    @objc(removeVehicleprofileObject:)
    @NSManaged func removeFromVehicleprofile(_ value: Vehicleprofile)

    @objc(addVehicleprofile:)
    @NSManaged func addToVehicleprofile(_ values: NSSet)

    @objc(removeVehicleprofile:)
    @NSManaged func removeFromVehicleprofile(_ values: NSSet)
}

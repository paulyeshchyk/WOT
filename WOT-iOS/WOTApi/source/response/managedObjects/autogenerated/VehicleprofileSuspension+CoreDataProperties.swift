//
//  VehicleprofileSuspension+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileSuspension {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileSuspension> {
        return NSFetchRequest<VehicleprofileSuspension>(entityName: "VehicleprofileSuspension")
    }

    @NSManaged var load_limit: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var steering_lock_angle: NSDecimalNumber?
    @NSManaged var suspension_id: NSDecimalNumber?
    @NSManaged var tag: String?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var traverse_speed: NSDecimalNumber?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var modules: NSSet?
    @NSManaged var vehicle: NSSet?
    @NSManaged var vehicleprofile: Vehicleprofile?
    @NSManaged var vehicleProfileModule: Module?
}

// MARK: Generated accessors for modules

public extension VehicleprofileSuspension {
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

public extension VehicleprofileSuspension {
    @objc(addVehicleObject:)
    @NSManaged func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged func removeFromVehicle(_ values: NSSet)
}

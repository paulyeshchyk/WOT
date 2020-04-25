//
//  VehicleprofileGun+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension VehicleprofileGun {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileGun> {
        return NSFetchRequest<VehicleprofileGun>(entityName: "VehicleprofileGun")
    }

    @NSManaged public var aim_time: NSDecimalNumber?
    @NSManaged public var caliber: NSDecimalNumber?
    @NSManaged public var dispersion: NSDecimalNumber?
    @NSManaged public var fire_rate: NSDecimalNumber?
    @NSManaged public var gun_id: NSDecimalNumber?
    @NSManaged public var move_down_arc: NSDecimalNumber?
    @NSManaged public var move_up_arc: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var reload_time: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var modules: NSSet?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleprofile: NSSet?
    @NSManaged public var vehicleprofileModule: Module?
}

// MARK: Generated accessors for modules
extension VehicleprofileGun {
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
extension VehicleprofileGun {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

// MARK: Generated accessors for vehicleprofile
extension VehicleprofileGun {
    @objc(addVehicleprofileObject:)
    @NSManaged public func addToVehicleprofile(_ value: Vehicleprofile)

    @objc(removeVehicleprofileObject:)
    @NSManaged public func removeFromVehicleprofile(_ value: Vehicleprofile)

    @objc(addVehicleprofile:)
    @NSManaged public func addToVehicleprofile(_ values: NSSet)

    @objc(removeVehicleprofile:)
    @NSManaged public func removeFromVehicleprofile(_ values: NSSet)
}

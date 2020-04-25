//
//  VehicleprofileSuspension+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
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
    @NSManaged public var steering_lock_angle: NSDecimalNumber?
    @NSManaged public var suspension_id: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var traverse_speed: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var modules: NSSet?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleProfileModule: Module?
}

// MARK: Generated accessors for modules
extension VehicleprofileSuspension {
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
extension VehicleprofileSuspension {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

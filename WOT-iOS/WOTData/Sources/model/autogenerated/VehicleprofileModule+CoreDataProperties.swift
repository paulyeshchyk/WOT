//
//  VehicleprofileModule+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

extension VehicleprofileModule {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileModule> {
        return NSFetchRequest<VehicleprofileModule>(entityName: "VehicleprofileModule")
    }

    @NSManaged public var engine_id: NSDecimalNumber?
    @NSManaged public var gun_id: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var radio_id: NSDecimalNumber?
    @NSManaged public var suspension_id: NSDecimalNumber?
    @NSManaged public var turret_id: NSDecimalNumber?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleChassis: VehicleprofileSuspension?
    @NSManaged public var vehicleEngine: VehicleprofileEngine?
    @NSManaged public var vehicleGun: VehicleprofileGun?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleRadio: VehicleprofileRadio?
    @NSManaged public var vehicleTurret: VehicleprofileTurret?
}

// MARK: Generated accessors for vehicle
extension VehicleprofileModule {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

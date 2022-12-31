//
//  VehicleprofileModule+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileModule {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileModule> {
        return NSFetchRequest<VehicleprofileModule>(entityName: "VehicleprofileModule")
    }

    @NSManaged var engine_id: NSDecimalNumber?
    @NSManaged var gun_id: NSDecimalNumber?
    @NSManaged var module_id: NSDecimalNumber?
    @NSManaged var radio_id: NSDecimalNumber?
    @NSManaged var suspension_id: NSDecimalNumber?
    @NSManaged var turret_id: NSDecimalNumber?
    @NSManaged var vehicle: NSSet?
    @NSManaged var vehicleChassis: VehicleprofileSuspension?
    @NSManaged var vehicleEngine: VehicleprofileEngine?
    @NSManaged var vehicleGun: VehicleprofileGun?
    @NSManaged var vehicleprofile: Vehicleprofile?
    @NSManaged var vehicleRadio: VehicleprofileRadio?
    @NSManaged var vehicleTurret: VehicleprofileTurret?
}

// MARK: Generated accessors for vehicle

public extension VehicleprofileModule {
    @objc(addVehicleObject:)
    @NSManaged func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged func removeFromVehicle(_ values: NSSet)
}

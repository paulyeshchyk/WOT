//
//  VehicleprofileAmmoList+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension VehicleprofileAmmoList {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmoList> {
        return NSFetchRequest<VehicleprofileAmmoList>(entityName: "VehicleprofileAmmoList")
    }

    @NSManaged var vehicleprofile: Vehicleprofile?
    @NSManaged var vehicleprofileAmmo: NSSet?
}

// MARK: Generated accessors for vehicleprofileAmmo

public extension VehicleprofileAmmoList {
    @objc(addVehicleprofileAmmoObject:)
    @NSManaged func addToVehicleprofileAmmo(_ value: VehicleprofileAmmo)

    @objc(removeVehicleprofileAmmoObject:)
    @NSManaged func removeFromVehicleprofileAmmo(_ value: VehicleprofileAmmo)

    @objc(addVehicleprofileAmmo:)
    @NSManaged func addToVehicleprofileAmmo(_ values: NSSet)

    @objc(removeVehicleprofileAmmo:)
    @NSManaged func removeFromVehicleprofileAmmo(_ values: NSSet)
}

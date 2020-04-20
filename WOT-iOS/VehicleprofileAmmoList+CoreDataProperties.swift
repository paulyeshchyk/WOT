//
//  VehicleprofileAmmoList+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension VehicleprofileAmmoList {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmoList> {
        return NSFetchRequest<VehicleprofileAmmoList>(entityName: "VehicleprofileAmmoList")
    }

    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleprofileAmmo: NSSet?
}

// MARK: Generated accessors for vehicleprofileAmmo
extension VehicleprofileAmmoList {
    @objc(addVehicleprofileAmmoObject:)
    @NSManaged public func addToVehicleprofileAmmo(_ value: VehicleprofileAmmo)

    @objc(removeVehicleprofileAmmoObject:)
    @NSManaged public func removeFromVehicleprofileAmmo(_ value: VehicleprofileAmmo)

    @objc(addVehicleprofileAmmo:)
    @NSManaged public func addToVehicleprofileAmmo(_ values: NSSet)

    @objc(removeVehicleprofileAmmo:)
    @NSManaged public func removeFromVehicleprofileAmmo(_ values: NSSet)
}

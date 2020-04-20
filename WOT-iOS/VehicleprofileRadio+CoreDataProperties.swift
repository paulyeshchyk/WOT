//
//  VehicleprofileRadio+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension VehicleprofileRadio {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileRadio> {
        return NSFetchRequest<VehicleprofileRadio>(entityName: "VehicleprofileRadio")
    }

    @NSManaged public var name: String?
    @NSManaged public var radio_id: NSDecimalNumber?
    @NSManaged public var signal_range: NSDecimalNumber?
    @NSManaged public var tag: String?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var vehicle: NSSet?
    @NSManaged public var vehicleprofile: Vehicleprofile?
    @NSManaged public var vehicleprofileModule: VehicleprofileModule?
}

// MARK: Generated accessors for vehicle
extension VehicleprofileRadio {
    @objc(addVehicleObject:)
    @NSManaged public func addToVehicle(_ value: Vehicles)

    @objc(removeVehicleObject:)
    @NSManaged public func removeFromVehicle(_ value: Vehicles)

    @objc(addVehicle:)
    @NSManaged public func addToVehicle(_ values: NSSet)

    @objc(removeVehicle:)
    @NSManaged public func removeFromVehicle(_ values: NSSet)
}

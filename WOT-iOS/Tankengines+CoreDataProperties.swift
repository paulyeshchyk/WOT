//
//  Tankengines+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Tankengines {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tankengines> {
        return NSFetchRequest<Tankengines>(entityName: "Tankengines")
    }

    @NSManaged public var fire_starting_chance: NSDecimalNumber?
    @NSManaged public var level: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var power: NSDecimalNumber?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_gold: NSDecimalNumber?
    @NSManaged public var profileModule: NSSet?
    @NSManaged public var vehicleprofileEngines: NSSet?
    @NSManaged public var vehicles: NSSet?
}

// MARK: Generated accessors for profileModule
extension Tankengines {
    @objc(addProfileModuleObject:)
    @NSManaged public func addToProfileModule(_ value: VehicleprofileModule)

    @objc(removeProfileModuleObject:)
    @NSManaged public func removeFromProfileModule(_ value: VehicleprofileModule)

    @objc(addProfileModule:)
    @NSManaged public func addToProfileModule(_ values: NSSet)

    @objc(removeProfileModule:)
    @NSManaged public func removeFromProfileModule(_ values: NSSet)
}

// MARK: Generated accessors for vehicleprofileEngines
extension Tankengines {
    @objc(addVehicleprofileEnginesObject:)
    @NSManaged public func addToVehicleprofileEngines(_ value: VehicleprofileEngine)

    @objc(removeVehicleprofileEnginesObject:)
    @NSManaged public func removeFromVehicleprofileEngines(_ value: VehicleprofileEngine)

    @objc(addVehicleprofileEngines:)
    @NSManaged public func addToVehicleprofileEngines(_ values: NSSet)

    @objc(removeVehicleprofileEngines:)
    @NSManaged public func removeFromVehicleprofileEngines(_ values: NSSet)
}

// MARK: Generated accessors for vehicles
extension Tankengines {
    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicles)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicles)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)
}

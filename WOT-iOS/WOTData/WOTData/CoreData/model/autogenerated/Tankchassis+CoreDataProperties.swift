//
//  Tankchassis+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Tankchassis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tankchassis> {
        return NSFetchRequest<Tankchassis>(entityName: "Tankchassis")
    }

    @NSManaged public var level: NSDecimalNumber?
    @NSManaged public var max_load: NSNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_gold: NSDecimalNumber?
    @NSManaged public var rotation_speed: NSDecimalNumber?
    @NSManaged public var modulesTree: NSSet?
    @NSManaged public var vehicleprofileSuspension: NSSet?
    @NSManaged public var vehicles: NSSet?
    @NSManaged public var profileModule: NSSet?

}

// MARK: Generated accessors for modulesTree
extension Tankchassis {

    @objc(addModulesTreeObject:)
    @NSManaged public func addToModulesTree(_ value: ModulesTree)

    @objc(removeModulesTreeObject:)
    @NSManaged public func removeFromModulesTree(_ value: ModulesTree)

    @objc(addModulesTree:)
    @NSManaged public func addToModulesTree(_ values: NSSet)

    @objc(removeModulesTree:)
    @NSManaged public func removeFromModulesTree(_ values: NSSet)

}

// MARK: Generated accessors for vehicleprofileSuspension
extension Tankchassis {

    @objc(addVehicleprofileSuspensionObject:)
    @NSManaged public func addToVehicleprofileSuspension(_ value: VehicleprofileSuspension)

    @objc(removeVehicleprofileSuspensionObject:)
    @NSManaged public func removeFromVehicleprofileSuspension(_ value: VehicleprofileSuspension)

    @objc(addVehicleprofileSuspension:)
    @NSManaged public func addToVehicleprofileSuspension(_ values: NSSet)

    @objc(removeVehicleprofileSuspension:)
    @NSManaged public func removeFromVehicleprofileSuspension(_ values: NSSet)

}

// MARK: Generated accessors for vehicles
extension Tankchassis {

    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicles)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicles)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)

}

// MARK: Generated accessors for profileModule
extension Tankchassis {

    @objc(addProfileModuleObject:)
    @NSManaged public func addToProfileModule(_ value: VehicleprofileModule)

    @objc(removeProfileModuleObject:)
    @NSManaged public func removeFromProfileModule(_ value: VehicleprofileModule)

    @objc(addProfileModule:)
    @NSManaged public func addToProfileModule(_ values: NSSet)

    @objc(removeProfileModule:)
    @NSManaged public func removeFromProfileModule(_ values: NSSet)

}

//
//  Tankturrets+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Tankturrets {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tankturrets> {
        return NSFetchRequest<Tankturrets>(entityName: "Tankturrets")
    }

    @NSManaged public var armor_board: NSDecimalNumber?
    @NSManaged public var armor_fedd: NSDecimalNumber?
    @NSManaged public var armor_forehead: NSDecimalNumber?
    @NSManaged public var circular_vision_radius: NSDecimalNumber?
    @NSManaged public var level: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_gold: NSDecimalNumber?
    @NSManaged public var rotation_speed: NSDecimalNumber?
    @NSManaged public var modulesTree: NSSet?
    @NSManaged public var vehicleprofileTurrets: VehicleprofileTurret?
    @NSManaged public var vehicles: NSSet?
    @NSManaged public var profileModule: NSSet?
}

// MARK: Generated accessors for modulesTree
extension Tankturrets {
    @objc(addModulesTreeObject:)
    @NSManaged public func addToModulesTree(_ value: ModulesTree)

    @objc(removeModulesTreeObject:)
    @NSManaged public func removeFromModulesTree(_ value: ModulesTree)

    @objc(addModulesTree:)
    @NSManaged public func addToModulesTree(_ values: NSSet)

    @objc(removeModulesTree:)
    @NSManaged public func removeFromModulesTree(_ values: NSSet)
}

// MARK: Generated accessors for vehicles
extension Tankturrets {
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
extension Tankturrets {
    @objc(addProfileModuleObject:)
    @NSManaged public func addToProfileModule(_ value: VehicleprofileModule)

    @objc(removeProfileModuleObject:)
    @NSManaged public func removeFromProfileModule(_ value: VehicleprofileModule)

    @objc(addProfileModule:)
    @NSManaged public func addToProfileModule(_ values: NSSet)

    @objc(removeProfileModule:)
    @NSManaged public func removeFromProfileModule(_ values: NSSet)
}

//
//  Tankguns+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Tankguns {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tankguns> {
        return NSFetchRequest<Tankguns>(entityName: "Tankguns")
    }

    @NSManaged public var level: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_gold: NSDecimalNumber?
    @NSManaged public var rate: NSDecimalNumber?
    @NSManaged public var modulesTree: NSSet?
    @NSManaged public var profileModule: NSSet?
    @NSManaged public var vehicleprofileGun: NSSet?
    @NSManaged public var vehicles: NSSet?
}

// MARK: Generated accessors for modulesTree
extension Tankguns {
    @objc(addModulesTreeObject:)
    @NSManaged public func addToModulesTree(_ value: ModulesTree)

    @objc(removeModulesTreeObject:)
    @NSManaged public func removeFromModulesTree(_ value: ModulesTree)

    @objc(addModulesTree:)
    @NSManaged public func addToModulesTree(_ values: NSSet)

    @objc(removeModulesTree:)
    @NSManaged public func removeFromModulesTree(_ values: NSSet)
}

// MARK: Generated accessors for profileModule
extension Tankguns {
    @objc(addProfileModuleObject:)
    @NSManaged public func addToProfileModule(_ value: VehicleprofileModule)

    @objc(removeProfileModuleObject:)
    @NSManaged public func removeFromProfileModule(_ value: VehicleprofileModule)

    @objc(addProfileModule:)
    @NSManaged public func addToProfileModule(_ values: NSSet)

    @objc(removeProfileModule:)
    @NSManaged public func removeFromProfileModule(_ values: NSSet)
}

// MARK: Generated accessors for vehicleprofileGun
extension Tankguns {
    @objc(addVehicleprofileGunObject:)
    @NSManaged public func addToVehicleprofileGun(_ value: VehicleprofileGun)

    @objc(removeVehicleprofileGunObject:)
    @NSManaged public func removeFromVehicleprofileGun(_ value: VehicleprofileGun)

    @objc(addVehicleprofileGun:)
    @NSManaged public func addToVehicleprofileGun(_ values: NSSet)

    @objc(removeVehicleprofileGun:)
    @NSManaged public func removeFromVehicleprofileGun(_ values: NSSet)
}

// MARK: Generated accessors for vehicles
extension Tankguns {
    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicles)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicles)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)
}

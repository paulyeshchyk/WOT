//
//  Vehicleprofile+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension Vehicleprofile {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Vehicleprofile> {
        return NSFetchRequest<Vehicleprofile>(entityName: "Vehicleprofile")
    }

    @NSManaged var hashName: NSDecimalNumber?
    @NSManaged var hp: NSDecimalNumber?
    @NSManaged var hull_hp: NSDecimalNumber?
    @NSManaged var hull_weight: NSDecimalNumber?
    @NSManaged var is_default: NSNumber?
    @NSManaged var max_ammo: NSDecimalNumber?
    @NSManaged var max_weight: NSDecimalNumber?
    @NSManaged var profile_id: NSDecimalNumber?
    @NSManaged var speed_backward: NSDecimalNumber?
    @NSManaged var speed_forward: NSDecimalNumber?
    @NSManaged var tank_id: NSDecimalNumber?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var ammo: VehicleprofileAmmoList?
    @NSManaged var armor: VehicleprofileArmorList?
    @NSManaged var engine: VehicleprofileEngine?
    @NSManaged var gun: VehicleprofileGun?
    @NSManaged var modules: VehicleprofileModule?
    @NSManaged var modulesTree: NSSet?
    @NSManaged var radio: VehicleprofileRadio?
    @NSManaged var suspension: VehicleprofileSuspension?
    @NSManaged var turret: VehicleprofileTurret?
    @NSManaged var vehicles: Vehicles?
}

// MARK: Generated accessors for modulesTree

public extension Vehicleprofile {
    @objc(addModulesTreeObject:)
    @NSManaged func addToModulesTree(_ value: ModulesTree)

    @objc(removeModulesTreeObject:)
    @NSManaged func removeFromModulesTree(_ value: ModulesTree)

    @objc(addModulesTree:)
    @NSManaged func addToModulesTree(_ values: NSSet)

    @objc(removeModulesTree:)
    @NSManaged func removeFromModulesTree(_ values: NSSet)
}

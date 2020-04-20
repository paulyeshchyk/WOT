//
//  Vehicleprofile+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Vehicleprofile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicleprofile> {
        return NSFetchRequest<Vehicleprofile>(entityName: "Vehicleprofile")
    }

    @NSManaged public var hashName: NSDecimalNumber?
    @NSManaged public var hp: NSDecimalNumber?
    @NSManaged public var hull_hp: NSDecimalNumber?
    @NSManaged public var hull_weight: NSDecimalNumber?
    @NSManaged public var is_default: NSNumber?
    @NSManaged public var max_ammo: NSDecimalNumber?
    @NSManaged public var max_weight: NSDecimalNumber?
    @NSManaged public var profile_id: NSDecimalNumber?
    @NSManaged public var speed_backward: NSDecimalNumber?
    @NSManaged public var speed_forward: NSDecimalNumber?
    @NSManaged public var tank_id: NSDecimalNumber?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var ammo: VehicleprofileAmmoList?
    @NSManaged public var armor: VehicleprofileArmorList?
    @NSManaged public var engine: VehicleprofileEngine?
    @NSManaged public var gun: VehicleprofileGun?
    @NSManaged public var modules: VehicleprofileModule?
    @NSManaged public var modulesTree: ModulesTree?
    @NSManaged public var radio: VehicleprofileRadio?
    @NSManaged public var suspension: VehicleprofileSuspension?
    @NSManaged public var turret: VehicleprofileTurret?
    @NSManaged public var vehicles: Vehicles?
}

//
//  Vehicles+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension Vehicles {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Vehicles> {
        return NSFetchRequest<Vehicles>(entityName: "Vehicles")
    }

    @NSManaged var is_gift: NSNumber?
    @NSManaged var is_premium: NSNumber?
    @NSManaged var is_premium_igr: NSNumber?
    @NSManaged var is_wheeled: NSNumber?
    @NSManaged var name: String?
    @NSManaged var nation: String?
    @NSManaged var price_credit: NSNumber?
    @NSManaged var price_gold: NSNumber?
    @NSManaged var short_name: String?
    @NSManaged var tag: String?
    @NSManaged var tank_id: NSDecimalNumber?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var type: String?
    @NSManaged var default_profile: Vehicleprofile?
    @NSManaged var engines: NSSet?
    @NSManaged var guns: NSSet?
    @NSManaged var modules: NSSet?
    @NSManaged var modules_tree: NSSet?
    @NSManaged var radios: NSSet?
    @NSManaged var suspensions: NSSet?
    @NSManaged var turrets: NSSet?
}

// MARK: Generated accessors for engines

public extension Vehicles {
    @objc(addEnginesObject:)
    @NSManaged func addToEngines(_ value: VehicleprofileEngine)

    @objc(removeEnginesObject:)
    @NSManaged func removeFromEngines(_ value: VehicleprofileEngine)

    @objc(addEngines:)
    @NSManaged func addToEngines(_ values: NSSet)

    @objc(removeEngines:)
    @NSManaged func removeFromEngines(_ values: NSSet)
}

// MARK: Generated accessors for guns

public extension Vehicles {
    @objc(addGunsObject:)
    @NSManaged func addToGuns(_ value: VehicleprofileGun)

    @objc(removeGunsObject:)
    @NSManaged func removeFromGuns(_ value: VehicleprofileGun)

    @objc(addGuns:)
    @NSManaged func addToGuns(_ values: NSSet)

    @objc(removeGuns:)
    @NSManaged func removeFromGuns(_ values: NSSet)
}

// MARK: Generated accessors for modules

public extension Vehicles {
    @objc(addModulesObject:)
    @NSManaged func addToModules(_ value: VehicleprofileModule)

    @objc(removeModulesObject:)
    @NSManaged func removeFromModules(_ value: VehicleprofileModule)

    @objc(addModules:)
    @NSManaged func addToModules(_ values: NSSet)

    @objc(removeModules:)
    @NSManaged func removeFromModules(_ values: NSSet)
}

// MARK: Generated accessors for modules_tree

public extension Vehicles {
    @objc(addModules_treeObject:)
    @NSManaged func addToModules_tree(_ value: ModulesTree)

    @objc(removeModules_treeObject:)
    @NSManaged func removeFromModules_tree(_ value: ModulesTree)

    @objc(addModules_tree:)
    @NSManaged func addToModules_tree(_ values: NSSet)

    @objc(removeModules_tree:)
    @NSManaged func removeFromModules_tree(_ values: NSSet)
}

// MARK: Generated accessors for radios

public extension Vehicles {
    @objc(addRadiosObject:)
    @NSManaged func addToRadios(_ value: VehicleprofileRadio)

    @objc(removeRadiosObject:)
    @NSManaged func removeFromRadios(_ value: VehicleprofileRadio)

    @objc(addRadios:)
    @NSManaged func addToRadios(_ values: NSSet)

    @objc(removeRadios:)
    @NSManaged func removeFromRadios(_ values: NSSet)
}

// MARK: Generated accessors for suspensions

public extension Vehicles {
    @objc(addSuspensionsObject:)
    @NSManaged func addToSuspensions(_ value: VehicleprofileSuspension)

    @objc(removeSuspensionsObject:)
    @NSManaged func removeFromSuspensions(_ value: VehicleprofileSuspension)

    @objc(addSuspensions:)
    @NSManaged func addToSuspensions(_ values: NSSet)

    @objc(removeSuspensions:)
    @NSManaged func removeFromSuspensions(_ values: NSSet)
}

// MARK: Generated accessors for turrets

public extension Vehicles {
    @objc(addTurretsObject:)
    @NSManaged func addToTurrets(_ value: VehicleprofileTurret)

    @objc(removeTurretsObject:)
    @NSManaged func removeFromTurrets(_ value: VehicleprofileTurret)

    @objc(addTurrets:)
    @NSManaged func addToTurrets(_ values: NSSet)

    @objc(removeTurrets:)
    @NSManaged func removeFromTurrets(_ values: NSSet)
}

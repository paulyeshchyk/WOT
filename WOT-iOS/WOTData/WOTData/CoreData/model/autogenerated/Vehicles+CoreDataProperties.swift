//
//  Vehicles+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Vehicles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicles> {
        return NSFetchRequest<Vehicles>(entityName: "Vehicles")
    }

    @NSManaged public var is_gift: NSNumber?
    @NSManaged public var is_premium: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSNumber?
    @NSManaged public var price_gold: NSNumber?
    @NSManaged public var short_name: String?
    @NSManaged public var tag: String?
    @NSManaged public var tank_id: NSDecimalNumber?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var is_wheeled: NSNumber?
    @NSManaged public var is_premium_igr: NSNumber?
    @NSManaged public var default_profile: Vehicleprofile?
    @NSManaged public var engines: NSSet?
    @NSManaged public var guns: NSSet?
    @NSManaged public var modules_tree: NSSet?
    @NSManaged public var radios: NSSet?
    @NSManaged public var suspensions: NSSet?
    @NSManaged public var turrets: NSSet?

}

// MARK: Generated accessors for engines
extension Vehicles {

    @objc(addEnginesObject:)
    @NSManaged public func addToEngines(_ value: Tankengines)

    @objc(removeEnginesObject:)
    @NSManaged public func removeFromEngines(_ value: Tankengines)

    @objc(addEngines:)
    @NSManaged public func addToEngines(_ values: NSSet)

    @objc(removeEngines:)
    @NSManaged public func removeFromEngines(_ values: NSSet)

}

// MARK: Generated accessors for guns
extension Vehicles {

    @objc(addGunsObject:)
    @NSManaged public func addToGuns(_ value: Tankguns)

    @objc(removeGunsObject:)
    @NSManaged public func removeFromGuns(_ value: Tankguns)

    @objc(addGuns:)
    @NSManaged public func addToGuns(_ values: NSSet)

    @objc(removeGuns:)
    @NSManaged public func removeFromGuns(_ values: NSSet)

}

// MARK: Generated accessors for modules_tree
extension Vehicles {

    @objc(addModules_treeObject:)
    @NSManaged public func addToModules_tree(_ value: ModulesTree)

    @objc(removeModules_treeObject:)
    @NSManaged public func removeFromModules_tree(_ value: ModulesTree)

    @objc(addModules_tree:)
    @NSManaged public func addToModules_tree(_ values: NSSet)

    @objc(removeModules_tree:)
    @NSManaged public func removeFromModules_tree(_ values: NSSet)

}

// MARK: Generated accessors for radios
extension Vehicles {

    @objc(addRadiosObject:)
    @NSManaged public func addToRadios(_ value: Tankradios)

    @objc(removeRadiosObject:)
    @NSManaged public func removeFromRadios(_ value: Tankradios)

    @objc(addRadios:)
    @NSManaged public func addToRadios(_ values: NSSet)

    @objc(removeRadios:)
    @NSManaged public func removeFromRadios(_ values: NSSet)

}

// MARK: Generated accessors for suspensions
extension Vehicles {

    @objc(addSuspensionsObject:)
    @NSManaged public func addToSuspensions(_ value: Tankchassis)

    @objc(removeSuspensionsObject:)
    @NSManaged public func removeFromSuspensions(_ value: Tankchassis)

    @objc(addSuspensions:)
    @NSManaged public func addToSuspensions(_ values: NSSet)

    @objc(removeSuspensions:)
    @NSManaged public func removeFromSuspensions(_ values: NSSet)

}

// MARK: Generated accessors for turrets
extension Vehicles {

    @objc(addTurretsObject:)
    @NSManaged public func addToTurrets(_ value: Tankturrets)

    @objc(removeTurretsObject:)
    @NSManaged public func removeFromTurrets(_ value: Tankturrets)

    @objc(addTurrets:)
    @NSManaged public func addToTurrets(_ values: NSSet)

    @objc(removeTurrets:)
    @NSManaged public func removeFromTurrets(_ values: NSSet)

}

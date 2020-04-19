//
//  ModulesTree+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension ModulesTree {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModulesTree> {
        return NSFetchRequest<ModulesTree>(entityName: "ModulesTree")
    }

    @NSManaged public var is_default: NSNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_xp: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var defaultProfile: Vehicleprofile?
    @NSManaged public var next_chassis: NSSet?
    @NSManaged public var next_engines: NSSet?
    @NSManaged public var next_guns: NSSet?
    @NSManaged public var next_modules: NSSet?
    @NSManaged public var next_radios: NSSet?
    @NSManaged public var next_tanks: Vehicles?
    @NSManaged public var next_turrets: NSSet?
    @NSManaged public var prevModules: ModulesTree?
}

// MARK: Generated accessors for next_chassis
extension ModulesTree {
    @objc(addNext_chassisObject:)
    @NSManaged public func addToNext_chassis(_ value: Tankchassis)

    @objc(removeNext_chassisObject:)
    @NSManaged public func removeFromNext_chassis(_ value: Tankchassis)

    @objc(addNext_chassis:)
    @NSManaged public func addToNext_chassis(_ values: NSSet)

    @objc(removeNext_chassis:)
    @NSManaged public func removeFromNext_chassis(_ values: NSSet)
}

// MARK: Generated accessors for next_engines
extension ModulesTree {
    @objc(addNext_enginesObject:)
    @NSManaged public func addToNext_engines(_ value: Tankengines)

    @objc(removeNext_enginesObject:)
    @NSManaged public func removeFromNext_engines(_ value: Tankengines)

    @objc(addNext_engines:)
    @NSManaged public func addToNext_engines(_ values: NSSet)

    @objc(removeNext_engines:)
    @NSManaged public func removeFromNext_engines(_ values: NSSet)
}

// MARK: Generated accessors for next_guns
extension ModulesTree {
    @objc(addNext_gunsObject:)
    @NSManaged public func addToNext_guns(_ value: Tankguns)

    @objc(removeNext_gunsObject:)
    @NSManaged public func removeFromNext_guns(_ value: Tankguns)

    @objc(addNext_guns:)
    @NSManaged public func addToNext_guns(_ values: NSSet)

    @objc(removeNext_guns:)
    @NSManaged public func removeFromNext_guns(_ values: NSSet)
}

// MARK: Generated accessors for next_modules
extension ModulesTree {
    @objc(addNext_modulesObject:)
    @NSManaged public func addToNext_modules(_ value: Module)

    @objc(removeNext_modulesObject:)
    @NSManaged public func removeFromNext_modules(_ value: Module)

    @objc(addNext_modules:)
    @NSManaged public func addToNext_modules(_ values: NSSet)

    @objc(removeNext_modules:)
    @NSManaged public func removeFromNext_modules(_ values: NSSet)
}

// MARK: Generated accessors for next_radios
extension ModulesTree {
    @objc(addNext_radiosObject:)
    @NSManaged public func addToNext_radios(_ value: Tankradios)

    @objc(removeNext_radiosObject:)
    @NSManaged public func removeFromNext_radios(_ value: Tankradios)

    @objc(addNext_radios:)
    @NSManaged public func addToNext_radios(_ values: NSSet)

    @objc(removeNext_radios:)
    @NSManaged public func removeFromNext_radios(_ values: NSSet)
}

// MARK: Generated accessors for next_turrets
extension ModulesTree {
    @objc(addNext_turretsObject:)
    @NSManaged public func addToNext_turrets(_ value: Tankturrets)

    @objc(removeNext_turretsObject:)
    @NSManaged public func removeFromNext_turrets(_ value: Tankturrets)

    @objc(addNext_turrets:)
    @NSManaged public func addToNext_turrets(_ values: NSSet)

    @objc(removeNext_turrets:)
    @NSManaged public func removeFromNext_turrets(_ values: NSSet)
}

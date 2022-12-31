//
//  ModulesTree+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension ModulesTree {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ModulesTree> {
        return NSFetchRequest<ModulesTree>(entityName: "ModulesTree")
    }

    @NSManaged var is_default: NSNumber?
    @NSManaged var module_id: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var price_credit: NSDecimalNumber?
    @NSManaged var price_xp: NSDecimalNumber?
    @NSManaged var type: String?
    @NSManaged var default_profile: Vehicleprofile?
    @NSManaged var next_modules: NSSet?
    @NSManaged var next_tanks: NSSet?
    @NSManaged var currentModule: Module?
}

// MARK: Generated accessors for next_modules

public extension ModulesTree {
    @objc(addNext_modulesObject:)
    @NSManaged func addToNext_modules(_ value: Module)

    @objc(removeNext_modulesObject:)
    @NSManaged func removeFromNext_modules(_ value: Module)

    @objc(addNext_modules:)
    @NSManaged func addToNext_modules(_ values: NSSet)

    @objc(removeNext_modules:)
    @NSManaged func removeFromNext_modules(_ values: NSSet)
}

// MARK: Generated accessors for next_tanks

public extension ModulesTree {
    @objc(addNext_tanksObject:)
    @NSManaged func addToNext_tanks(_ value: Vehicles)

    @objc(removeNext_tanksObject:)
    @NSManaged func removeFromNext_tanks(_ value: Vehicles)

    @objc(addNext_tanks:)
    @NSManaged func addToNext_tanks(_ values: NSSet)

    @objc(removeNext_tanks:)
    @NSManaged func removeFromNext_tanks(_ values: NSSet)
}

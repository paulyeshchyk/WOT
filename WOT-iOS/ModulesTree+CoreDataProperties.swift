//
//  ModulesTree+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
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
    @NSManaged public var next_modules: NSSet?
    @NSManaged public var next_tanks: NSSet?
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

// MARK: Generated accessors for next_tanks
extension ModulesTree {
    @objc(addNext_tanksObject:)
    @NSManaged public func addToNext_tanks(_ value: Vehicles)

    @objc(removeNext_tanksObject:)
    @NSManaged public func removeFromNext_tanks(_ value: Vehicles)

    @objc(addNext_tanks:)
    @NSManaged public func addToNext_tanks(_ values: NSSet)

    @objc(removeNext_tanks:)
    @NSManaged public func removeFromNext_tanks(_ values: NSSet)
}

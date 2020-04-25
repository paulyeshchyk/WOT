//
//  Module+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Module {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Module> {
        return NSFetchRequest<Module>(entityName: "Module")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var engine: VehicleprofileEngine?
    @NSManaged public var gun: VehicleprofileGun?
    @NSManaged public var radio: VehicleprofileRadio?
    @NSManaged public var suspension: VehicleprofileSuspension?
    @NSManaged public var turret: VehicleprofileTurret?
    @NSManaged public var modulesTree: NSSet?
}

// MARK: Generated accessors for modulesTree
extension Module {
    @objc(addModulesTreeObject:)
    @NSManaged public func addToModulesTree(_ value: ModulesTree)

    @objc(removeModulesTreeObject:)
    @NSManaged public func removeFromModulesTree(_ value: ModulesTree)

    @objc(addModulesTree:)
    @NSManaged public func addToModulesTree(_ values: NSSet)

    @objc(removeModulesTree:)
    @NSManaged public func removeFromModulesTree(_ values: NSSet)
}

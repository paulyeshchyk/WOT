//
//  Module+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
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
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var tier: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var moduleTree: ModulesTree?
    @NSManaged public var tanks: NSSet?
}

// MARK: Generated accessors for tanks
extension Module {
    @objc(addTanksObject:)
    @NSManaged public func addToTanks(_ value: Vehicles)

    @objc(removeTanksObject:)
    @NSManaged public func removeFromTanks(_ value: Vehicles)

    @objc(addTanks:)
    @NSManaged public func addToTanks(_ values: NSSet)

    @objc(removeTanks:)
    @NSManaged public func removeFromTanks(_ values: NSSet)
}

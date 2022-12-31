//
//  Module+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension Module {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Module> {
        return NSFetchRequest<Module>(entityName: "Module")
    }

    @NSManaged var image: String?
    @NSManaged var module_id: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var nation: String?
    @NSManaged var price_credit: NSDecimalNumber?
    @NSManaged var tier: NSDecimalNumber?
    @NSManaged var type: String?
    @NSManaged var weight: NSDecimalNumber?
    @NSManaged var engine: VehicleprofileEngine?
    @NSManaged var gun: VehicleprofileGun?
    @NSManaged var modulesTree: ModulesTree?
    @NSManaged var radio: VehicleprofileRadio?
    @NSManaged var suspension: VehicleprofileSuspension?
    @NSManaged var turret: VehicleprofileTurret?
    @NSManaged var treeLink: ModulesTree?
}

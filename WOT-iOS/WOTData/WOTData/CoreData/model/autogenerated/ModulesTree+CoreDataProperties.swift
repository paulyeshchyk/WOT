//
//  ModulesTree+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/20/20.
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
    @NSManaged public var nextChassis: NSSet?
    @NSManaged public var nextEngines: NSSet?
    @NSManaged public var nextGuns: NSSet?
    @NSManaged public var nextModules: NSSet?
    @NSManaged public var nextRadios: NSSet?
    @NSManaged public var nextTurrets: NSSet?
    @NSManaged public var prevModules: ModulesTree?
    @NSManaged public var nextTanks: Vehicles?

}

// MARK: Generated accessors for nextChassis
extension ModulesTree {

    @objc(addNextChassisObject:)
    @NSManaged public func addToNextChassis(_ value: Tankchassis)

    @objc(removeNextChassisObject:)
    @NSManaged public func removeFromNextChassis(_ value: Tankchassis)

    @objc(addNextChassis:)
    @NSManaged public func addToNextChassis(_ values: NSSet)

    @objc(removeNextChassis:)
    @NSManaged public func removeFromNextChassis(_ values: NSSet)

}

// MARK: Generated accessors for nextEngines
extension ModulesTree {

    @objc(addNextEnginesObject:)
    @NSManaged public func addToNextEngines(_ value: Tankengines)

    @objc(removeNextEnginesObject:)
    @NSManaged public func removeFromNextEngines(_ value: Tankengines)

    @objc(addNextEngines:)
    @NSManaged public func addToNextEngines(_ values: NSSet)

    @objc(removeNextEngines:)
    @NSManaged public func removeFromNextEngines(_ values: NSSet)

}

// MARK: Generated accessors for nextGuns
extension ModulesTree {

    @objc(addNextGunsObject:)
    @NSManaged public func addToNextGuns(_ value: Tankguns)

    @objc(removeNextGunsObject:)
    @NSManaged public func removeFromNextGuns(_ value: Tankguns)

    @objc(addNextGuns:)
    @NSManaged public func addToNextGuns(_ values: NSSet)

    @objc(removeNextGuns:)
    @NSManaged public func removeFromNextGuns(_ values: NSSet)

}

// MARK: Generated accessors for nextModules
extension ModulesTree {

    @objc(addNextModulesObject:)
    @NSManaged public func addToNextModules(_ value: ModulesTree)

    @objc(removeNextModulesObject:)
    @NSManaged public func removeFromNextModules(_ value: ModulesTree)

    @objc(addNextModules:)
    @NSManaged public func addToNextModules(_ values: NSSet)

    @objc(removeNextModules:)
    @NSManaged public func removeFromNextModules(_ values: NSSet)

}

// MARK: Generated accessors for nextRadios
extension ModulesTree {

    @objc(addNextRadiosObject:)
    @NSManaged public func addToNextRadios(_ value: Tankradios)

    @objc(removeNextRadiosObject:)
    @NSManaged public func removeFromNextRadios(_ value: Tankradios)

    @objc(addNextRadios:)
    @NSManaged public func addToNextRadios(_ values: NSSet)

    @objc(removeNextRadios:)
    @NSManaged public func removeFromNextRadios(_ values: NSSet)

}

// MARK: Generated accessors for nextTurrets
extension ModulesTree {

    @objc(addNextTurretsObject:)
    @NSManaged public func addToNextTurrets(_ value: Tankturrets)

    @objc(removeNextTurretsObject:)
    @NSManaged public func removeFromNextTurrets(_ value: Tankturrets)

    @objc(addNextTurrets:)
    @NSManaged public func addToNextTurrets(_ values: NSSet)

    @objc(removeNextTurrets:)
    @NSManaged public func removeFromNextTurrets(_ values: NSSet)

}

//
//  VehicleprofileModule+CoreDataProperties.swift
//
//
//  Created by Pavel Yeshchyk on 4/23/20.
//
//

import Foundation
import CoreData

extension VehicleprofileModule {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileModule> {
        return NSFetchRequest<VehicleprofileModule>(entityName: "VehicleprofileModule")
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
    @NSManaged public var vehicleRadio: VehicleprofileRadio?
    @NSManaged public var vehicleEngine: VehicleprofileEngine?
    @NSManaged public var vehicleGun: VehicleprofileGun?
    @NSManaged public var vehicleChassis: VehicleprofileSuspension?
    @NSManaged public var vehicleTurret: VehicleprofileTurret?
    @NSManaged public var vehicleprofile: Vehicleprofile?
}

// MARK: Generated accessors for tanks
extension VehicleprofileModule {
    @objc(addTanksObject:)
    @NSManaged public func addToTanks(_ value: Vehicles)

    @objc(removeTanksObject:)
    @NSManaged public func removeFromTanks(_ value: Vehicles)

    @objc(addTanks:)
    @NSManaged public func addToTanks(_ values: NSSet)

    @objc(removeTanks:)
    @NSManaged public func removeFromTanks(_ values: NSSet)
}

//
//  Tankradios+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension Tankradios {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tankradios> {
        return NSFetchRequest<Tankradios>(entityName: "Tankradios")
    }

    @NSManaged public var distance: NSDecimalNumber?
    @NSManaged public var level: NSDecimalNumber?
    @NSManaged public var module_id: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var nation: String?
    @NSManaged public var price_credit: NSDecimalNumber?
    @NSManaged public var price_gold: NSDecimalNumber?
    @NSManaged public var profileModule: NSSet?
    @NSManaged public var vehicleprofileRadio: NSSet?
    @NSManaged public var vehicles: NSSet?
}

// MARK: Generated accessors for profileModule
extension Tankradios {
    @objc(addProfileModuleObject:)
    @NSManaged public func addToProfileModule(_ value: VehicleprofileModule)

    @objc(removeProfileModuleObject:)
    @NSManaged public func removeFromProfileModule(_ value: VehicleprofileModule)

    @objc(addProfileModule:)
    @NSManaged public func addToProfileModule(_ values: NSSet)

    @objc(removeProfileModule:)
    @NSManaged public func removeFromProfileModule(_ values: NSSet)
}

// MARK: Generated accessors for vehicleprofileRadio
extension Tankradios {
    @objc(addVehicleprofileRadioObject:)
    @NSManaged public func addToVehicleprofileRadio(_ value: VehicleprofileRadio)

    @objc(removeVehicleprofileRadioObject:)
    @NSManaged public func removeFromVehicleprofileRadio(_ value: VehicleprofileRadio)

    @objc(addVehicleprofileRadio:)
    @NSManaged public func addToVehicleprofileRadio(_ values: NSSet)

    @objc(removeVehicleprofileRadio:)
    @NSManaged public func removeFromVehicleprofileRadio(_ values: NSSet)
}

// MARK: Generated accessors for vehicles
extension Tankradios {
    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicles)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicles)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)
}

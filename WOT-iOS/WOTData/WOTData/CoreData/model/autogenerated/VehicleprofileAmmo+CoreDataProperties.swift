//
//  VehicleprofileAmmo+CoreDataProperties.swift
//
//
//  Created by Pavel Yeshchyk on 4/23/20.
//
//

import Foundation
import CoreData

extension VehicleprofileAmmo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileAmmo> {
        return NSFetchRequest<VehicleprofileAmmo>(entityName: "VehicleprofileAmmo")
    }

    @NSManaged public var type: String?
    @NSManaged public var damage: VehicleprofileAmmoDamage?
    @NSManaged public var penetration: VehicleprofileAmmoPenetration?
    @NSManaged public var vehicleprofileAmmoList: VehicleprofileAmmoList?
}

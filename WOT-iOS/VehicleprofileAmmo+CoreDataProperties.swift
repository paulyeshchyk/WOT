//
//  VehicleprofileAmmo+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
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

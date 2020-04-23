//
//  VehicleprofileModule+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension VehicleprofileModule {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleprofileModule> {
        return NSFetchRequest<VehicleprofileModule>(entityName: "VehicleprofileModule")
    }

    @NSManaged public var engine_id: NSDecimalNumber?
    @NSManaged public var gun_id: NSDecimalNumber?
    @NSManaged public var radio_id: NSDecimalNumber?
    @NSManaged public var suspension_id: NSDecimalNumber?
    @NSManaged public var turret_id: NSDecimalNumber?
    @NSManaged public var engine: VehicleprofileEngine?
    @NSManaged public var gun: VehicleprofileGun?
    @NSManaged public var radio: VehicleprofileRadio?
    @NSManaged public var suspension: VehicleprofileSuspension?
    @NSManaged public var turret: VehicleprofileTurret?
    @NSManaged public var vehicleProfile: Vehicleprofile?
}

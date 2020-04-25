//
//  VehicleprofileTurret_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileTurret {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(VehicleprofileTurret.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileTurret.tag)] as? String
        self.view_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.view_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.weight)] as? Int ?? 0)
        self.traverse_left_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_left_arc)] as? Int ?? 0)
        self.traverse_right_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_right_arc)] as? Int ?? 0)
        self.traverse_speed = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_speed)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.hp)] as? Int ?? 0)
    }
}

extension VehicleprofileTurret {
    public static func turret(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        let tag = jSON[VehicleprofileTurret.primaryKeyPath()]
        let pk = VehicleprofileTurret.primaryKey(for: tag as AnyObject?)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        coreDataMapping?.requestSubordinate(for: VehicleprofileTurret.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

//
//  VehicleprofileGun_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileGun {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(VehicleprofileGun.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileGun.tag)] as? String
        self.caliber = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.caliber)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.weight)] as? Int ?? 0)
        self.move_down_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.move_down_arc)] as? Int ?? 0)
        self.move_up_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.move_up_arc)] as? Int ?? 0)
        self.fire_rate = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.fire_rate)] as? Double ?? 0)
        self.dispersion = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.dispersion)] as? Double ?? 0)
        self.reload_time = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.reload_time)] as? Double ?? 0)
        self.aim_time = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileGun.aim_time)] as? Double ?? 0)
    }
}

extension VehicleprofileGun {
    public static func gun(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        let tag = jSON[VehicleprofileGun.primaryKeyPath()]
        let pk = VehicleprofileGun.primaryKey(for: tag as AnyObject?)
        let pkCase = PKCase()
        pkCase[.primary] = pk

        coreDataMapping?.requestSubordinate(for: VehicleprofileGun.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

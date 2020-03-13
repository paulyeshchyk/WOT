//
//  VehicleprofileGun_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileGun: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){ }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){

        defer {
            context.tryToSave()
        }

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



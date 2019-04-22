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
    public func mapping(from jSON: [AnyHashable: Any]){
        self.move_down_arc = jSON["move_down_arc"] as? NSDecimalNumber
        self.caliber = jSON["caliber"] as? NSDecimalNumber
        self.name = jSON["name"] as? String
        self.weight = jSON["weight"] as? NSDecimalNumber
        self.move_up_arc = jSON["move_up_arc"] as? NSDecimalNumber
        self.fire_rate = jSON["fire_rate"] as? NSDecimalNumber
        self.dispersion = jSON["dispersion"] as? NSDecimalNumber
        self.tag = jSON["tag"] as? String
        self.reload_time = jSON["reload_time"] as? NSDecimalNumber
        self.tier = jSON["tier"] as? NSDecimalNumber
        self.aim_time = jSON["aim_time"] as? NSDecimalNumber
    }
}



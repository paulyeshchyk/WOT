//
//  Vehicleprofile_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Vehicleprofile: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: [AnyHashable: Any]){
        self.max_ammo = jSON["max_ammo"] as? NSDecimalNumber
        self.weight = jSON["weight"] as? NSDecimalNumber
        self.hp = jSON["hp"] as? NSDecimalNumber
        self.is_default = jSON["is_default"] as? NSNumber
        self.hull_weight = jSON["hull_weight"] as? NSDecimalNumber
        self.speed_forward = jSON["speed_forward"] as? NSDecimalNumber
        self.hull_hp = jSON["hull_hp"] as? NSDecimalNumber
        self.speed_backward = jSON["speed_backward"] as? NSDecimalNumber
        self.tank_id = jSON["tank_id"] as? NSDecimalNumber
        self.max_weight = jSON["max_weight"] as? NSDecimalNumber

    }
}


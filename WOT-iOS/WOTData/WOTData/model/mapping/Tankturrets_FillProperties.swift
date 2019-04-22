//
//  Tankturrets_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Tankturrets: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case name
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(from jSON: [AnyHashable: Any]){
        self.module_id = jSON[WOTApiKeys.module_id] as? NSDecimalNumber
        self.name = jSON[WOTApiKeys.name] as? String
        self.armor_board = jSON[WOTApiKeys.armor_board] as? NSDecimalNumber
        self.armor_fedd = jSON[WOTApiKeys.armor_fedd] as? NSDecimalNumber
        self.armor_forehead = jSON[WOTApiKeys.armor_forehead] as? NSDecimalNumber
        self.circular_vision_radius = jSON[WOTApiKeys.circular_vision_radius] as? NSDecimalNumber
        self.level = jSON[WOTApiKeys.tier] as? NSDecimalNumber
        self.nation = jSON[WOTApiKeys.nation] as? String
        self.price_credit = jSON[WOTApiKeys.price_credit] as? NSDecimalNumber
        self.price_gold = jSON[WOTApiKeys.price_gold] as? NSDecimalNumber
        self.rotation_speed = jSON[WOTApiKeys.rotation_speed] as? NSDecimalNumber        
    }
}

//
//  TankEngines_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Tankengines: JSONMapperProtocol {

    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case fire_starting_chance
        case level
        case nation
        case power
        case price_credit
        case price_gold
    }

    public typealias Fields = FieldKeys
    

    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }
        self.module_id = jSON[WOTApiKeys.module_id] as? NSDecimalNumber
        self.name = jSON[WOTApiKeys.name] as? String
        
        self.fire_starting_chance = jSON[WOTApiKeys.fire_starting_chance] as? NSDecimalNumber
        self.level = jSON[WOTApiKeys.tier] as? NSDecimalNumber
        self.nation = jSON[WOTApiKeys.nation] as? String
        self.power = jSON[WOTApiKeys.power] as? NSDecimalNumber
        self.price_credit = jSON[WOTApiKeys.price_credit] as? NSDecimalNumber
        self.price_gold = jSON[WOTApiKeys.price_gold] as? NSDecimalNumber
    }
}

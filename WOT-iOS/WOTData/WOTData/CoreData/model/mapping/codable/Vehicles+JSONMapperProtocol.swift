//
//  Vehicles_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Vehicles: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case name
        case nation
        case price_credit
        case price_gold
        case is_premium
        case short_name
        case tag
        case tier
        case type
        case tank_id
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }
        
        
        self.name = jSON[WOTApiKeys.name] as? String
        self.nation = jSON[WOTApiKeys.nation] as? String
        self.price_credit = jSON[WOTApiKeys.price_credit] as? NSNumber
        self.price_gold = jSON[WOTApiKeys.price_gold] as? NSNumber
        self.is_premium = jSON[WOTApiKeys.is_premium] as? NSNumber
        self.short_name = jSON[WOTApiKeys.short_name] as? String
        self.tag = jSON[WOTApiKeys.tag] as? String
        self.tier = NSDecimalNumber(value: jSON[WOTApiKeys.tier] as? Int ?? 0)
        /*
         * can be
         * lightTank, SPG, AT-SPG, heavyTank, mediumTank
         */
        self.type = jSON[WOTApiKeys.type] as? String
        self.tank_id = NSDecimalNumber(value: jSON[WOTApiKeys.tank_id] as? Int ?? 0)
    }
}

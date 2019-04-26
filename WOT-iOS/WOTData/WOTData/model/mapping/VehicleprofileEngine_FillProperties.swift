//
//  VehicleprofileEngine_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileEngine: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case name
        case power
        case weight
        case tag
        case fire_chance
        case tier
    }
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(from jSON: Any){
        guard let jSON = jSON as? [AnyHashable: Any] else { return }
        self.name = jSON["name"] as? String
        self.power = jSON["power"] as? NSDecimalNumber
        self.weight = jSON["weight"] as? NSDecimalNumber
        self.tag = jSON["tag"] as? String
        self.fire_chance = jSON["fire_chance"] as? NSDecimalNumber
        self.tier = jSON["tier"] as? NSDecimalNumber
    }
}

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
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(Tankengines.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankengines.module_id)] as? Int ?? 0)
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankengines.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankengines.nation)] as? String
        self.fire_starting_chance = NSDecimalNumber(value: jSON[#keyPath(Tankengines.fire_starting_chance)] as? Int ?? 0)
        self.power = NSDecimalNumber(value: jSON[#keyPath(Tankengines.power)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankengines.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankengines.price_gold)] as? Int ?? 0)
    }
}

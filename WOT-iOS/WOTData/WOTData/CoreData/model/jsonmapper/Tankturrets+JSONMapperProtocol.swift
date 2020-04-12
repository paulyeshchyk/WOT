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
    public func mapping(fromArray jSON: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(Tankturrets.name)] as? String
        self.nation = jSON[#keyPath(Tankturrets.nation)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.level)] as? Int ?? 0)
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.module_id)] as? Int ?? 0)
        self.armor_board = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_board)] as? Int ?? 0)
        self.armor_fedd = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_fedd)] as? Int ?? 0)
        self.armor_forehead = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.armor_forehead)] as? Int ?? 0)
        self.circular_vision_radius = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.circular_vision_radius)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.price_gold)] as? Int ?? 0)
        self.rotation_speed = NSDecimalNumber(value: jSON[#keyPath(Tankturrets.rotation_speed)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankturrets.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}

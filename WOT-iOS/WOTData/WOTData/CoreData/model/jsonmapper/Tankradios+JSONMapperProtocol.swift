//
//  Tankradios_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankradios: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankradios.name),
                #keyPath(Tankradios.module_id),
                #keyPath(Tankradios.distance),
                #keyPath(Tankradios.nation),
                #keyPath(Tankradios.price_credit),
                #keyPath(Tankradios.price_gold)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankradios.keypaths()
    }
}

extension Tankradios: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case name
    }

    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(Tankradios.name)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankradios.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankradios.nation)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankradios.module_id)] as? Int ?? 0)
        self.distance = NSDecimalNumber(value: jSON[#keyPath(Tankradios.distance)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_gold)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankradios.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}

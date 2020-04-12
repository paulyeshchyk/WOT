//
//  Tankguns_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Tankguns: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankguns.name),
                #keyPath(Tankguns.module_id),
                #keyPath(Tankguns.nation),
                #keyPath(Tankguns.price_credit),
                #keyPath(Tankguns.price_gold),
                #keyPath(Tankguns.rate)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankguns.keypaths()
    }
}

extension Tankguns: JSONMapperProtocol {
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

        self.name = jSON[#keyPath(Tankguns.name)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankguns.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankguns.nation)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankguns.module_id)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankguns.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankguns.price_gold)] as? Int ?? 0)
        self.rate = NSDecimalNumber(value: jSON[#keyPath(Tankguns.rate)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Tankguns.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}

//
//  VehicleprofileEngine_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileEngine: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileEngine.name),
                #keyPath(VehicleprofileEngine.power),
                #keyPath(VehicleprofileEngine.weight),
                #keyPath(VehicleprofileEngine.tag),
                #keyPath(VehicleprofileEngine.fire_chance),
                #keyPath(VehicleprofileEngine.tier)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileEngine.keypaths()
    }
}

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
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
            jsonLinksCallback?(nil)
        }

        self.name = jSON[#keyPath(VehicleprofileEngine.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.tier)]  as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileEngine.tag)] as? String
        self.power = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.power)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.weight)]  as? Int ?? 0)
        self.fire_chance = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileEngine.fire_chance)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileEngine.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, jsonLinksCallback: jsonLinksCallback)
    }
}

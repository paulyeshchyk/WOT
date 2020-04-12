//
//  VehicleprofileArmor_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileArmor: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case front
        case sides
        case rear
    }

    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        self.front = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.front)] as? Int ?? 0)
        self.sides = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.sides)] as? Int ?? 0)
        self.rear = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.rear)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileArmor.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}

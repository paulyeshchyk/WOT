//
//  VehicleprofileArmor_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileArmor: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileArmor.front),
                #keyPath(VehicleprofileArmor.sides),
                #keyPath(VehicleprofileArmor.rear)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileArmor.keypaths()
    }
}

extension VehicleprofileArmor {
    public enum FieldKeys: String, CodingKey {
        case front
        case sides
        case rear
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.front = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.front)] as? Int ?? 0)
        self.sides = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.sides)] as? Int ?? 0)
        self.rear = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileArmor.rear)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileArmor.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, externalPK: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

#warning("add PrimaryKeypathProtocol support")

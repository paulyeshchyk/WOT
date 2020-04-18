//
//  VehicleprofileTurret_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileTurret: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileTurret.traverse_left_arc),
                #keyPath(VehicleprofileTurret.traverse_speed),
                #keyPath(VehicleprofileTurret.weight),
                #keyPath(VehicleprofileTurret.view_range),
                #keyPath(VehicleprofileTurret.hp),
                #keyPath(VehicleprofileTurret.tier),
                #keyPath(VehicleprofileTurret.name),
                #keyPath(VehicleprofileTurret.tag),
                #keyPath(VehicleprofileTurret.traverse_right_arc)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileTurret.keypaths()
    }
}

extension VehicleprofileTurret {
    public typealias Fields = Void

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(VehicleprofileTurret.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileTurret.tag)] as? String
        self.view_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.view_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.weight)] as? Int ?? 0)
        self.traverse_left_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_left_arc)] as? Int ?? 0)
        self.traverse_right_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_right_arc)] as? Int ?? 0)
        self.traverse_speed = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_speed)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.hp)] as? Int ?? 0)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileTurret.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileTurret {
    public static func turret(fromJSON json: Any?, primaryKey pkProfile: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileTurret? {
        guard let json = json as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileTurret.self, pkProfile) as? VehicleprofileTurret else { return nil }
        result.mapping(fromJSON: json, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

#warning("add PrimaryKeypathProtocol support")

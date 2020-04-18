//
//  VehicleprofileArmorList+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension VehicleprofileArmorList {
    public enum FieldKeys: String, CodingKey {
        case type
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        if let hullJSON = jSON[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            if let hullObject = onSubordinateCreate?(VehicleprofileArmor.self, nil) as? VehicleprofileArmor {
                hullObject.mapping(fromJSON: hullJSON, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
                self.hull = hullObject
            }
        }

        if let turretJSON = jSON[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            if let turretObject = onSubordinateCreate?(VehicleprofileArmor.self, nil) as? VehicleprofileArmor {
                turretObject.mapping(fromJSON: turretJSON, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
                self.turret = turretObject
            }
        }
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileArmorList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileArmorList {
    public static func list(fromJSON json: Any?, primaryKey pkProfile: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileArmorList? {
        guard let json = json as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(VehicleprofileArmorList.self, pkProfile) as? VehicleprofileArmorList else { return nil }
        result.mapping(fromJSON: json, parentPrimaryKey: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

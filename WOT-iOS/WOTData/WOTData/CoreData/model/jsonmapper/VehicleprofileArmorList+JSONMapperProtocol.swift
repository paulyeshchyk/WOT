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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, subordinator: CoreDataSubordinatorProtocol?, linksCallback: OnLinksCallback?) {
        #warning("use subordinator")
        /*
         if let hullJSON = jSON[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
             if let hullObject = subordinator?(VehicleprofileArmor.self, pkCase) as? VehicleprofileArmor {
                 hullObject.mapping(fromJSON: hullJSON, pkCase: pkCase, subordinator: subordinator, linksCallback: linksCallback)
                 self.hull = hullObject
             }
         }

         if let turretJSON = jSON[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
             if let turretObject = subordinator?(VehicleprofileArmor.self, pkCase) as? VehicleprofileArmor {
                 turretObject.mapping(fromJSON: turretJSON, pkCase: pkCase, subordinator: subordinator, linksCallback: linksCallback)
                 self.turret = turretObject
             }
         }
         */
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = VehicleprofileArmorList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromJSON: json, pkCase: pkCase, subordinator: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileArmorList {
    public static func list(fromJSON json: Any?, pkCase: PKCase, subordinator: CoreDataSubordinatorProtocol?, linksCallback: OnLinksCallback?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        subordinator?.requestNewSubordinate(VehicleprofileArmorList.self, pkCase) { newObject in
            newObject?.mapping(fromJSON: json, pkCase: pkCase, subordinator: subordinator, linksCallback: linksCallback)
            callback(newObject)
        }
    }
}

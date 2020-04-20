//
//  VehicleprofileAmmoList_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoList {
    public typealias Fields = Void

    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            if let ammoObject = onSubordinateCreate?(VehicleprofileAmmo.self, pkCase) as? VehicleprofileAmmo {
                ammoObject.mapping(fromJSON: jSON, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
                self.addToVehicleprofileAmmo(ammoObject)
            }
        }
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromArray: array, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileAmmoList {
    public static func list(fromArray array: Any?, pkCase: PKCase, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> VehicleprofileAmmoList? {
        guard let array = array as? [Any] else { return  nil }

        guard let result = onSubordinateCreate?(VehicleprofileAmmoList.self, pkCase) as? VehicleprofileAmmoList else { return nil }

        result.mapping(fromArray: array, pkCase: pkCase, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

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
    public override func mapping(fromArray array: [Any], pkCase: PKCase, subordinator: CoreDataSubordinatorProtocol?, linksCallback: OnLinksCallback?) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            subordinator?.requestNewSubordinate(VehicleprofileAmmo.self, pkCase) { [weak self] newObject in
                guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                    return
                }
                ammo.mapping(fromJSON: jSON, pkCase: pkCase, subordinator: subordinator, linksCallback: linksCallback)
                self.addToVehicleprofileAmmo(ammo)
            }
        }
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        self.mapping(fromArray: array, pkCase: pkCase, subordinator: nil, linksCallback: linksCallback)
    }
}

extension VehicleprofileAmmoList {
    public static func list(fromArray array: Any?, pkCase: PKCase, subordinator: CoreDataSubordinatorProtocol?, linksCallback: OnLinksCallback?, callback:  @escaping NSManagedObjectCallback ) {
        guard let array = array as? [Any] else { return }

        subordinator?.requestNewSubordinate(VehicleprofileAmmoList.self, pkCase) { newObject in
            newObject?.mapping(fromArray: array, pkCase: pkCase, subordinator: subordinator, linksCallback: linksCallback)
            callback(newObject)
        }
    }
}

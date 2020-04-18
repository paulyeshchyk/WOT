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
    public override func mapping(fromArray array: [Any], parentPrimaryKey: WOTPrimaryKey, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        #warning("refactoring")
//        array.compactMap { $0 as? JSON }.forEach { (jSON) in
//
//            if let ammoObject = VehicleprofileAmmo(json: jSON, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback) {
//                self.addToVehicleprofileAmmo(ammoObject)
//            }
//        }
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: OnLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

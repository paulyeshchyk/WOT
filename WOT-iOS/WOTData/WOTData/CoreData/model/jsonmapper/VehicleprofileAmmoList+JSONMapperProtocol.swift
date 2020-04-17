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
    public override func mapping(fromArray array: [Any], into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            if let ammoObject = VehicleprofileAmmo(json: jSON, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback) {
                self.addToVehicleprofileAmmo(ammoObject)
            }
        }
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, parentPrimaryKey: PrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
    }
}

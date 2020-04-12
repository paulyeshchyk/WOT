//
//  VehicleprofileAmmoList_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoList: JSONMapperProtocol {
    public typealias Fields = Void

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            if let ammoObject = VehicleprofileAmmo(json: jSON, into: context, jsonLinksCallback: jsonLinksCallback) {
                self.addToVehicleprofileAmmo(ammoObject)
            }
        }
    }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    convenience init?(array: Any?, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromArray: array, into: context, jsonLinksCallback: jsonLinksCallback)
    }
}

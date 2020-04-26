//
//  VehicleprofileAmmoList_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileAmmoList {
    public typealias Fields = Void

    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject)
            persistentStore?.requestSubordinate(for: VehicleprofileAmmo.self, pkCase: vehicleprofileAmmoCase, subordinateRequestType: .local, keyPathPrefix: nil) { [weak self] newObject in
                guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                    return
                }
                persistentStore?.mapping(object: ammo, fromJSON: jSON, pkCase: vehicleprofileAmmoCase, forRequest: forRequest)
                self.addToVehicleprofileAmmo(ammo)
                persistentStore?.stash(hint: vehicleprofileAmmoCase)
            }
        }
    }
}

extension VehicleprofileAmmoList {
    public static func list(fromArray array: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?, callback:  @escaping NSManagedObjectCallback ) {
        guard let array = array as? [Any] else { return }

        persistentStore?.requestSubordinate(for: VehicleprofileAmmoList.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromArray: array, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

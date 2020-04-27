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
    public override func mapping(fromArray array: [Any], pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = RemotePKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject)
            persistentStore?.localSubordinate(for: VehicleprofileAmmo.self, pkCase: vehicleprofileAmmoCase) { [weak self] newObject in
                guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                    return
                }
                persistentStore?.mapping(object: ammo, fromJSON: jSON, pkCase: vehicleprofileAmmoCase)
                self.addToVehicleprofileAmmo(ammo)
                persistentStore?.stash(hint: vehicleprofileAmmoCase)
            }
        }
    }
}

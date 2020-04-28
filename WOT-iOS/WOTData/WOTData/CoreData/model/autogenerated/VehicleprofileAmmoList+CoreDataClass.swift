//
//  VehicleprofileAmmoList+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmoList)
public class VehicleprofileAmmoList: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileAmmoList {
    public typealias Fields = Void

    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject)
            do {
                try persistentStore?.fetchLocal(byModelClass: VehicleprofileAmmo.self, pkCase: vehicleprofileAmmoCase) { [weak self] newObject in
                    guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                        return
                    }
                    do {
                        try persistentStore?.mapping(object: ammo, fromJSON: jSON, pkCase: vehicleprofileAmmoCase)
                        self.addToVehicleprofileAmmo(ammo)
                        persistentStore?.stash(hint: vehicleprofileAmmoCase)
                    } catch let error {
                        print(error)
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
}

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
    public override func mapping(context: NSManagedObjectContext, fromArray array: [Any], pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject, andType: .internal)

            persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileAmmo.self, pkCase: vehicleprofileAmmoCase) { [weak self] fetchResult in
                let context = fetchResult.context
                guard let self = self, let ammo = fetchResult.managedObject() as? VehicleprofileAmmo else {
                    return
                }
                do {
                    try persistentStore?.mapping(context: context, object: ammo, fromJSON: jSON, pkCase: vehicleprofileAmmoCase) { error in

                        self.addToVehicleprofileAmmo(ammo)
                        persistentStore?.stash(context: context, hint: vehicleprofileAmmoCase) { error in
                            if let error = error {
                                print(error.debugDescription)
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }
}

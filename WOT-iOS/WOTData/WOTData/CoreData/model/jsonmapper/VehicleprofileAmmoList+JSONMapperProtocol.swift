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
    public override func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject)
            coreDataMapping?.pullLocalSubordinate(for: VehicleprofileAmmo.self, vehicleprofileAmmoCase) { [weak self] newObject in
                guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                    return
                }
                coreDataMapping?.mapping(object: ammo, fromJSON: jSON, pkCase: vehicleprofileAmmoCase, forRequest: forRequest)
                self.addToVehicleprofileAmmo(ammo)
                coreDataMapping?.stash(vehicleprofileAmmoCase)
            }
        }
    }
}

extension VehicleprofileAmmoList {
    public static func list(fromArray array: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback:  @escaping NSManagedObjectCallback ) {
        guard let array = array as? [Any] else { return }

        coreDataMapping?.pullLocalSubordinate(for: VehicleprofileAmmoList.self, pkCase) { newObject in
            coreDataMapping?.mapping(object: newObject, fromArray: array, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

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
        defer {
            coreDataMapping?.stash(pkCase)
        }

        array.compactMap { $0 as? JSON }.forEach { (jSON) in

            let vehicleprofileAmmoCase = PKCase()
            vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList))
            vehicleprofileAmmoCase[.secondary] = VehicleprofileAmmo.primaryKey(for: jSON[#keyPath(VehicleprofileAmmo.type)] as AnyObject)
            coreDataMapping?.requestNewSubordinate(VehicleprofileAmmo.self, vehicleprofileAmmoCase) { [weak self] newObject in
                guard let self = self, let ammo = newObject as? VehicleprofileAmmo else {
                    return
                }
                ammo.mapping(fromJSON: jSON, pkCase: vehicleprofileAmmoCase, forRequest: forRequest, coreDataMapping: coreDataMapping)
                self.addToVehicleprofileAmmo(ammo)
                coreDataMapping?.stash(vehicleprofileAmmoCase)
            }
        }
    }

    convenience init?(array: Any?, into context: NSManagedObjectContext, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        guard let array = array as? [Any], let entityDescription = VehicleprofileAmmoList.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        self.mapping(fromArray: array, pkCase: pkCase, forRequest: forRequest, coreDataMapping: coreDataMapping)
    }
}

extension VehicleprofileAmmoList {
    public static func list(fromArray array: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback:  @escaping NSManagedObjectCallback ) {
        guard let array = array as? [Any] else { return }

        coreDataMapping?.requestNewSubordinate(VehicleprofileAmmoList.self, pkCase) { newObject in
            newObject?.mapping(fromArray: array, pkCase: pkCase, forRequest: forRequest, coreDataMapping: coreDataMapping)
            callback(newObject)
        }
    }
}

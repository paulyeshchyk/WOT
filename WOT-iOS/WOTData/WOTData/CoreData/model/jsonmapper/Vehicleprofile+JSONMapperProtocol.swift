//
//  Vehicleprofile_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension Vehicleprofile {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
        var parents = pkCase.plainParents
        parents.append(self)

        let vehicleprofileAmmoListCase = PKCase(parentObjects: parents)
        vehicleprofileAmmoListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
        VehicleprofileAmmoList.list(fromArray: jSON[#keyPath(Vehicleprofile.ammo)], pkCase: vehicleprofileAmmoListCase, persistentStore: persistentStore) { newObject in
            self.ammo = newObject as? VehicleprofileAmmoList
            persistentStore?.stash(hint: vehicleprofileAmmoListCase)
        }

        let vehicleprofileArmorListCase = PKCase(parentObjects: parents)
        vehicleprofileArmorListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
        VehicleprofileArmorList.list(fromJSON: jSON[#keyPath(Vehicleprofile.armor)], pkCase: vehicleprofileArmorListCase, persistentStore: persistentStore) { newObject in
            self.armor = newObject as? VehicleprofileArmorList
            persistentStore?.stash(hint: vehicleprofileArmorListCase)
        }

        let vehicleprofileEngineListCase = PKCase(parentObjects: parents)
        vehicleprofileEngineListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileEngine.vehicleprofile))
        VehicleprofileEngine.engine(fromJSON: jSON[#keyPath(Vehicleprofile.engine)], pkCase: vehicleprofileEngineListCase, persistentStore: persistentStore) { newObject in
            self.engine = newObject as? VehicleprofileEngine
            persistentStore?.stash(hint: vehicleprofileEngineListCase)
        }

        let vehicleprofileGunListCase = PKCase(parentObjects: parents)
        vehicleprofileGunListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileGun.vehicleprofile))
        VehicleprofileGun.gun(fromJSON: jSON[#keyPath(Vehicleprofile.gun)], pkCase: vehicleprofileGunListCase, persistentStore: persistentStore) { newObject in
            self.gun = newObject as? VehicleprofileGun
            persistentStore?.stash(hint: vehicleprofileGunListCase)
        }

        let vehicleprofileRadioListCase = PKCase(parentObjects: parents)
        vehicleprofileRadioListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileRadio.vehicleprofile))
        VehicleprofileRadio.radio(fromJSON: jSON[#keyPath(Vehicleprofile.radio)], pkCase: vehicleprofileRadioListCase, persistentStore: persistentStore) { newObject in
            self.radio = newObject as? VehicleprofileRadio
            persistentStore?.stash(hint: vehicleprofileRadioListCase)
        }

        let vehicleprofileSuspensionListCase = PKCase(parentObjects: parents)
        vehicleprofileSuspensionListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileSuspension.vehicleprofile))
        VehicleprofileSuspension.suspension(fromJSON: jSON[#keyPath(Vehicleprofile.suspension)], pkCase: vehicleprofileSuspensionListCase, persistentStore: persistentStore) { newObject in
            self.suspension = newObject as? VehicleprofileSuspension
            persistentStore?.stash(hint: vehicleprofileSuspensionListCase)
        }

        let vehicleprofileTurretCase = PKCase(parentObjects: parents)
        vehicleprofileTurretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileTurret.vehicleprofile))
        VehicleprofileTurret.turret(fromJSON: jSON[#keyPath(Vehicleprofile.turret)], pkCase: vehicleprofileTurretCase, persistentStore: persistentStore) { newObject in
            self.turret = newObject as? VehicleprofileTurret
            persistentStore?.stash(hint: vehicleprofileTurretCase)
        }

        let vehicleprofileModuleCase = PKCase(parentObjects: parents)
        vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
        VehicleprofileModule.module(fromJSON: jSON[#keyPath(Vehicleprofile.modules)], pkCase: vehicleprofileModuleCase, persistentStore: persistentStore) { newObject in
            self.modules = newObject as? VehicleprofileModule
            persistentStore?.stash(hint: vehicleprofileModuleCase)
        }
    }
}

extension Vehicleprofile {
    public static func profile(fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        persistentStore?.requestSubordinate(for: Vehicleprofile.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }
}

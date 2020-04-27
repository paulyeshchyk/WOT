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
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
        var parents = pkCase.plainParents
        parents.append(self)

        if let itemsList = jSON[#keyPath(Vehicleprofile.ammo)] as? [Any] {
            let itemCase = RemotePKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileAmmoList.self, items: itemsList, pkCase: itemCase) { newObject in
                self.ammo = newObject as? VehicleprofileAmmoList
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = RemotePKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileArmorList.self, itemJSON: itemJSON, pkCase: itemCase) { newObject in
                self.armor = newObject as? VehicleprofileArmorList
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath()] {
                let pkCase = RemotePKCase()
                pkCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileEngine.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.engine = newObject as? VehicleprofileEngine
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath()] {
                let pkCase = RemotePKCase()
                pkCase[.primary] = VehicleprofileGun.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileGun.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.gun = newObject as? VehicleprofileGun
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath()] {
                let pkCase = RemotePKCase()
                pkCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileRadio.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.radio = newObject as? VehicleprofileRadio
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath()] {
                let pkCase = RemotePKCase()
                pkCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileSuspension.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.suspension = newObject as? VehicleprofileSuspension
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath()] {
                let pkCase = RemotePKCase()
                pkCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileTurret.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.turret = newObject as? VehicleprofileTurret
                }
            }
        }

        if let moduleJSON = jSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let vehicleprofileModuleCase = RemotePKCase(parentObjects: parents)
            vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileModule.self, itemJSON: moduleJSON, pkCase: vehicleprofileModuleCase) { newObject in
                self.modules = newObject as? VehicleprofileModule
            }
        }
    }
}

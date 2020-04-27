//
//  VehicleProfileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileModule {
    override public func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let gunCase = RemotePKCase()
        gunCase[.primary] = VehicleprofileGun.primaryIdKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", onCreateNSManagedObject: { (managedObject) in
            if let gun = managedObject as? VehicleprofileGun {
                self.vehicleGun = gun
                persistentStore?.stash(hint: gunCase)
            }
        })

        let radioCase = RemotePKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryIdKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", onCreateNSManagedObject: { (managedObject) in
            if let radio = managedObject as? VehicleprofileRadio {
                self.vehicleRadio = radio
                persistentStore?.stash(hint: radioCase)
            }
        })
        let engineCase = RemotePKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryIdKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", onCreateNSManagedObject: { (managedObject) in
            if let engine = managedObject as? VehicleprofileEngine {
                self.vehicleEngine = engine
                persistentStore?.stash(hint: engineCase)
            }
        })
        let suspensionCase = RemotePKCase()
        suspensionCase[.primary] = VehicleprofileSuspension.primaryIdKey(for: self.suspension_id)
        suspensionCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", onCreateNSManagedObject: { (managedObject) in
            if let suspension = managedObject as? VehicleprofileSuspension {
                self.vehicleChassis = suspension
                persistentStore?.stash(hint: suspensionCase)
            }
        })

        //turret is optional device, turret_id can be null
        if let turret_id = self.turret_id {
            let turretCase = RemotePKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryIdKey(for: turret_id)
            turretCase[.secondary] = pkCase[.primary]
            persistentStore?.remoteSubordinate(for: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", onCreateNSManagedObject: { (managedObject) in
                if let turret = managedObject as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    persistentStore?.stash(hint: turretCase)
                }
            })
        }
    }
}

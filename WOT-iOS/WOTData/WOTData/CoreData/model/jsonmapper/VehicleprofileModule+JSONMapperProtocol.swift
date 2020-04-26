//
//  VehicleProfileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileModule {
    override public func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let gunCase = PKCase()
        gunCase[.primary] = VehicleprofileGun.primaryIdKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        persistentStore?.requestSubordinate(for: VehicleprofileGun.self, pkCase: gunCase, subordinateRequestType: .remote, keyPathPrefix: "gun.", onCreateNSManagedObject: { (managedObject) in
            if let gun = managedObject as? VehicleprofileGun {
                self.vehicleGun = gun
                persistentStore?.stash(hint: gunCase)
            }
        })

        let radioCase = PKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryIdKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        persistentStore?.requestSubordinate(for: VehicleprofileRadio.self, pkCase: radioCase, subordinateRequestType: .remote, keyPathPrefix: "radio.", onCreateNSManagedObject: { (managedObject) in
            if let radio = managedObject as? VehicleprofileRadio {
                self.vehicleRadio = radio
                persistentStore?.stash(hint: radioCase)
            }
        })
        let engineCase = PKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryIdKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        persistentStore?.requestSubordinate(for: VehicleprofileEngine.self, pkCase: engineCase, subordinateRequestType: .remote, keyPathPrefix: "engine.", onCreateNSManagedObject: { (managedObject) in
            if let engine = managedObject as? VehicleprofileEngine {
                self.vehicleEngine = engine
                persistentStore?.stash(hint: engineCase)
            }
        })
        let suspensionCase = PKCase()
        suspensionCase[.primary] = VehicleprofileSuspension.primaryIdKey(for: self.suspension_id)
        suspensionCase[.secondary] = pkCase[.primary]
        persistentStore?.requestSubordinate(for: VehicleprofileSuspension.self, pkCase: suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "suspension.", onCreateNSManagedObject: { (managedObject) in
            if let suspension = managedObject as? VehicleprofileSuspension {
                self.vehicleChassis = suspension
                persistentStore?.stash(hint: suspensionCase)
            }
        })

        //turret is optional device, turret_id can be null
        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryIdKey(for: turret_id)
            turretCase[.secondary] = pkCase[.primary]
            persistentStore?.requestSubordinate(for: VehicleprofileTurret.self, pkCase: suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "turret.", onCreateNSManagedObject: { (managedObject) in
                if let turret = managedObject as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    persistentStore?.stash(hint: turretCase)
                }
            })
        }
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        persistentStore?.requestSubordinate(for: VehicleprofileModule.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: json, pkCase: pkCase)
            callback(newObject)
        }
    }
}

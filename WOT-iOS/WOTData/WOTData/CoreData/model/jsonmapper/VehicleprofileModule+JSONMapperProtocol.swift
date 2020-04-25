//
//  VehicleProfileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileModule {
    override public func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let gunCase = PKCase()
        gunCase[.primary] = VehicleprofileGun.primaryIdKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileGun.self, gunCase, subordinateRequestType: .remote, keyPathPrefix: "gun.", callback: { (managedObject) in
            if let gun = managedObject as? VehicleprofileGun {
                self.vehicleGun = gun
                coreDataMapping?.stash(hint: gunCase)
            }
        })

        let radioCase = PKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryIdKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileRadio.self, radioCase, subordinateRequestType: .remote, keyPathPrefix: "radio.", callback: { (managedObject) in
            if let radio = managedObject as? VehicleprofileRadio {
                self.vehicleRadio = radio
                coreDataMapping?.stash(hint: radioCase)
            }
        })
        let engineCase = PKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryIdKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileEngine.self, engineCase, subordinateRequestType: .remote, keyPathPrefix: "engine.", callback: { (managedObject) in
            if let engine = managedObject as? VehicleprofileEngine {
                self.vehicleEngine = engine
                coreDataMapping?.stash(hint: engineCase)
            }
        })
        let suspensionCase = PKCase()
        suspensionCase[.primary] = VehicleprofileSuspension.primaryIdKey(for: self.suspension_id)
        suspensionCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileSuspension.self, suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "suspension.", callback: { (managedObject) in
            if let suspension = managedObject as? VehicleprofileSuspension {
                self.vehicleChassis = suspension
                coreDataMapping?.stash(hint: suspensionCase)
            }
        })

        //turret is optional device, turret_id can be null
        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryIdKey(for: turret_id)
            turretCase[.secondary] = pkCase[.primary]
            coreDataMapping?.requestSubordinate(for: VehicleprofileTurret.self, suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "turret.", callback: { (managedObject) in
                if let turret = managedObject as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    coreDataMapping?.stash(hint: turretCase)
                }
            })
        }
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestSubordinate(for: VehicleprofileModule.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

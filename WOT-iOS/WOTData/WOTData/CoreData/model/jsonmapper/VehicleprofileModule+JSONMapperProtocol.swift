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
        self.radio_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.radio_id)]).asNSDecimal
        self.suspension_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.suspension_id)]).asNSDecimal
        self.engine_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.engine_id)]).asNSDecimal
        self.gun_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.gun_id)]).asNSDecimal
        self.turret_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.turret_id)]).asNSDecimal

        let gunCase = PKCase()
        gunCase[.primary] = VehicleprofileGun.primaryKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileGun.self, gunCase, subordinateRequestType: .remote, keyPathPrefix: "gun.", callback: { (managedObject) in
            if let gun = managedObject as? VehicleprofileGun {
                self.vehicleGun = gun
                coreDataMapping?.stash(gunCase)
            }
        })

        let radioCase = PKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileRadio.self, radioCase, subordinateRequestType: .remote, keyPathPrefix: "radio.", callback: { (managedObject) in
            if let radio = managedObject as? VehicleprofileRadio {
                self.vehicleRadio = radio
                coreDataMapping?.stash(radioCase)
            }
        })
        let engineCase = PKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        coreDataMapping?.requestSubordinate(for: VehicleprofileEngine.self, engineCase, subordinateRequestType: .remote, keyPathPrefix: "engine.", callback: { (managedObject) in
            if let engine = managedObject as? VehicleprofileEngine {
                self.vehicleEngine = engine
                coreDataMapping?.stash(engineCase)
            }
        })
//        let suspensionCase = PKCase()
//        suspensionCase[.primary] = VehicleprofileSuspension.primaryKey(for: self.suspension_id)
//        suspensionCase[.secondary] = pkCase[.primary]
//        coreDataMapping?.requestSubordinate(for: VehicleprofileSuspension.self, suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "default_profile.", callback: { (managedObject) in
//            if let suspension = managedObject as? VehicleprofileSuspension {
//                self.vehicleChassis = suspension
//                coreDataMapping?.stash(suspensionCase)
//            }
//        })
//        let turretCase = PKCase()
//        turretCase[.primary] = VehicleprofileTurret.primaryKey(for: self.turret_id)
//        turretCase[.secondary] = pkCase[.primary]
//        coreDataMapping?.requestSubordinate(for: VehicleprofileTurret.self, suspensionCase, subordinateRequestType: .remote, keyPathPrefix: "default_profile.", callback: { (managedObject) in
//            if let turret = managedObject as? VehicleprofileTurret {
//                self.vehicleTurret = turret
//                coreDataMapping?.stash(turretCase)
//            }
//        })
    }
}

extension VehicleprofileModule: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileModule.module_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
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

//
//  Vehicleprofile_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension Vehicleprofile: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Vehicleprofile.max_ammo),
                #keyPath(Vehicleprofile.weight),
                #keyPath(Vehicleprofile.hp),
                #keyPath(Vehicleprofile.is_default),
                #keyPath(Vehicleprofile.modules),
//                #keyPath(Vehicleprofile.modulesTree),
//                #keyPath(Vehicleprofile.vehicles),
                #keyPath(Vehicleprofile.speed_forward),
                #keyPath(Vehicleprofile.hull_hp),
                #keyPath(Vehicleprofile.speed_backward),
                #keyPath(Vehicleprofile.tank_id),
                #keyPath(Vehicleprofile.max_weight)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Vehicleprofile.keypaths()
    }
}

extension Vehicleprofile {
    public enum FieldKeys: String, CodingKey {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.tank_id = AnyConvertable(jSON[#keyPath(Vehicleprofile.tank_id)]).asNSDecimal
        self.is_default = AnyConvertable(jSON[#keyPath(Vehicleprofile.is_default)]).asNSDecimal
        self.max_ammo = AnyConvertable(jSON[#keyPath(Vehicleprofile.max_ammo)]).asNSDecimal
        self.max_weight = AnyConvertable(jSON[#keyPath(Vehicleprofile.max_weight)]).asNSDecimal
        self.weight = AnyConvertable(jSON[#keyPath(Vehicleprofile.weight)]).asNSDecimal
        self.hp = AnyConvertable(jSON[#keyPath(Vehicleprofile.hp)]).asNSDecimal
        self.hull_hp = AnyConvertable(jSON[#keyPath(Vehicleprofile.hull_hp)]).asNSDecimal
        self.hull_weight = AnyConvertable(jSON[#keyPath(Vehicleprofile.hull_weight)]).asNSDecimal
        self.speed_backward = AnyConvertable(jSON[#keyPath(Vehicleprofile.speed_backward)]).asNSDecimal
        self.speed_forward = AnyConvertable(jSON[#keyPath(Vehicleprofile.speed_forward)]).asNSDecimal

        let vehicleprofileAmmoListCase = PKCase()
        vehicleprofileAmmoListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
        VehicleprofileAmmoList.list(fromArray: jSON[#keyPath(Vehicleprofile.ammo)], pkCase: vehicleprofileAmmoListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.ammo = newObject as? VehicleprofileAmmoList
            coreDataMapping?.stash(vehicleprofileAmmoListCase)
        }

        let vehicleprofileArmorListCase = PKCase()
        vehicleprofileArmorListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
        VehicleprofileArmorList.list(fromJSON: jSON[#keyPath(Vehicleprofile.armor)], pkCase: vehicleprofileArmorListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.armor = newObject as? VehicleprofileArmorList
            coreDataMapping?.stash(vehicleprofileArmorListCase)
        }

        let vehicleprofileEngineListCase = PKCase()
        vehicleprofileEngineListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileEngine.vehicleprofile))
        VehicleprofileEngine.engine(fromJSON: jSON[#keyPath(Vehicleprofile.engine)], pkCase: vehicleprofileEngineListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.engine = newObject as? VehicleprofileEngine
            coreDataMapping?.stash(vehicleprofileEngineListCase)
        }

        let vehicleprofileGunListCase = PKCase()
        vehicleprofileGunListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileGun.vehicleprofile))
        VehicleprofileGun.gun(fromJSON: jSON[#keyPath(Vehicleprofile.gun)], pkCase: vehicleprofileGunListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.gun = newObject as? VehicleprofileGun
            coreDataMapping?.stash(vehicleprofileGunListCase)
        }

        let vehicleprofileRadioListCase = PKCase()
        vehicleprofileRadioListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileRadio.vehicleprofile))
        VehicleprofileRadio.radio(fromJSON: jSON[#keyPath(Vehicleprofile.radio)], pkCase: vehicleprofileRadioListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.radio = newObject as? VehicleprofileRadio
            coreDataMapping?.stash(vehicleprofileRadioListCase)
        }

        let vehicleprofileSuspensionListCase = PKCase()
        vehicleprofileSuspensionListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileSuspension.vehicleprofile))
        VehicleprofileSuspension.suspension(fromJSON: jSON[#keyPath(Vehicleprofile.suspension)], pkCase: vehicleprofileSuspensionListCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.suspension = newObject as? VehicleprofileSuspension
            coreDataMapping?.stash(vehicleprofileSuspensionListCase)
        }

        let vehicleprofileTurretCase = PKCase()
        vehicleprofileTurretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileTurret.vehicleprofile))
        VehicleprofileTurret.turret(fromJSON: jSON[#keyPath(Vehicleprofile.turret)], pkCase: vehicleprofileTurretCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.turret = newObject as? VehicleprofileTurret
            coreDataMapping?.stash(vehicleprofileTurretCase)
        }

        let vehicleprofileModuleCase = PKCase()
        vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleProfile))
        VehicleprofileModule.module(fromJSON: jSON[#keyPath(Vehicleprofile.modules)], pkCase: vehicleprofileModuleCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.modules = newObject as? VehicleprofileModule
            coreDataMapping?.stash(vehicleprofileModuleCase)
        }
    }
}

extension Vehicleprofile: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Vehicleprofile.hashName)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}

extension Vehicleprofile {
    public static func profile(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        coreDataMapping?.pullLocalSubordinate(Vehicleprofile.self, pkCase) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

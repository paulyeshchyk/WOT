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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?) {
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

        subordinator?.willRequestLinks()

//        let vehicleprofileAmmoListCase = PKCase()
//        vehicleprofileAmmoListCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
//
//        VehicleprofileAmmoList.list(fromArray: jSON[#keyPath(Vehicleprofile.ammo)], pkCase: vehicleprofileAmmoListCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.ammo = newObject as? VehicleprofileAmmoList
//        }
//        VehicleprofileArmorList.list(fromJSON: jSON[#keyPath(Vehicleprofile.armor)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.armor = newObject as? VehicleprofileArmorList
//        }
//        VehicleprofileEngine.engine(fromJSON: jSON[#keyPath(Vehicleprofile.engine)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.engine = newObject as? VehicleprofileEngine
//        }
//        VehicleprofileGun.gun(fromJSON: jSON[#keyPath(Vehicleprofile.gun)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.gun = newObject as? VehicleprofileGun
//        }
//        VehicleprofileRadio.radio(fromJSON: jSON[#keyPath(Vehicleprofile.radio)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.radio = newObject as? VehicleprofileRadio
//        }
//        VehicleprofileSuspension.suspension(fromJSON: jSON[#keyPath(Vehicleprofile.suspension)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.suspension = newObject as? VehicleprofileSuspension
//        }
//        VehicleprofileTurret.turret(fromJSON: jSON[#keyPath(Vehicleprofile.turret)], pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
//            self.turret = newObject as? VehicleprofileTurret
//        }

        let vehicleprofileModuleCase = PKCase()
        vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleProfile))
        VehicleprofileModule.module(fromJSON: jSON[#keyPath(Vehicleprofile.modules)], pkCase: vehicleprofileModuleCase, forRequest: forRequest, subordinator: subordinator, linker: linker) { newObject in
            self.modules = newObject as? VehicleprofileModule
        }
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol, linker: CoreDataLinkerProtocol?) {
        guard let json = json as? JSON, let entityDescription = Vehicleprofile.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey
        self.mapping(fromJSON: json, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
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
    public static func profile(fromJSON jSON: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, subordinator: CoreDataSubordinatorProtocol?, linker: CoreDataLinkerProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else { return }

        subordinator?.requestNewSubordinate(Vehicleprofile.self, pkCase) { newObject in
            newObject?.mapping(fromJSON: jSON, pkCase: pkCase, forRequest: forRequest, subordinator: subordinator, linker: linker)
            callback(newObject)
        }
    }
}

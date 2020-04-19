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
    public override func mapping(fromJSON jSON: JSON, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.tank_id = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.tank_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.is_default)] as? Int ?? 0)
        self.max_ammo = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.max_ammo)] as? Int ?? 0)
        self.max_weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.max_weight)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.weight)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hp)] as? Int ?? 0)
        self.hull_hp = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hull_hp)] as? Int ?? 0)
        self.hull_weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hull_weight)] as? Int ?? 0)
        self.speed_backward = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.speed_backward)] as? Int ?? 0)
        self.speed_forward = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.speed_forward)] as? Int ?? 0)

        self.ammo = VehicleprofileAmmoList.list(fromArray: jSON[#keyPath(Vehicleprofile.ammo)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.armor = VehicleprofileArmorList.list(fromJSON: jSON[#keyPath(Vehicleprofile.armor)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.engine = VehicleprofileEngine.engine(fromJSON: jSON[#keyPath(Vehicleprofile.engine)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.gun = VehicleprofileGun.gun(fromJSON: jSON[#keyPath(Vehicleprofile.gun)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.radio = VehicleprofileRadio.radio(fromJSON: jSON[#keyPath(Vehicleprofile.radio)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.suspension = VehicleprofileSuspension.suspension(fromJSON: jSON[#keyPath(Vehicleprofile.suspension)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.turret = VehicleprofileTurret.turret(fromJSON: jSON[#keyPath(Vehicleprofile.turret)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        self.modules = VehicleprofileModule.module(fromJSON: jSON[#keyPath(Vehicleprofile.modules)], externalPK: nil, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = Vehicleprofile.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, externalPK: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
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
    public static func profile(from jSON: Any?, externalPK: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) -> Vehicleprofile? {
        guard let jSON = jSON as? JSON else { return  nil }
        guard let result = onSubordinateCreate?(Vehicleprofile.self, externalPK) as? Vehicleprofile else { return nil }

        result.mapping(fromJSON: jSON, externalPK: externalPK, onSubordinateCreate: onSubordinateCreate, linksCallback: linksCallback)
        return result
    }
}

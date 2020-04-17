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
    public override func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
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

        self.ammo = VehicleprofileAmmoList(array: jSON[#keyPath(Vehicleprofile.ammo)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.armor = VehicleprofileArmorList(json: jSON[#keyPath(Vehicleprofile.armor)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.engine = VehicleprofileEngine(json: jSON[#keyPath(Vehicleprofile.engine)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.gun = VehicleprofileGun(json: jSON[#keyPath(Vehicleprofile.gun)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.radio = VehicleprofileRadio(json: jSON[#keyPath(Vehicleprofile.radio)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.suspension = VehicleprofileSuspension(json: jSON[#keyPath(Vehicleprofile.suspension)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.turret = VehicleprofileTurret(json: jSON[#keyPath(Vehicleprofile.turret)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        self.modules = VehicleprofileModule(json: jSON[#keyPath(Vehicleprofile.modules)], into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
        context.tryToSave()
        linksCallback(nil)
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {
        guard let json = json as? JSON, let entityDescription = Vehicleprofile.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, into: context, parentPrimaryKey: parentPrimaryKey, linksCallback: linksCallback)
    }
}

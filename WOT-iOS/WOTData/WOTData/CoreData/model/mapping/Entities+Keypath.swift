//
//  Tankengines+Keypath.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc extension ModulesTree {
    public static func keypaths() -> [String] {
        return [#keyPath(ModulesTree.name),
                #keyPath(ModulesTree.module_id),
                #keyPath(ModulesTree.price_credit)]
    }
}

@objc extension Tankengines {
    public static func keypaths() -> [String] {
        return [#keyPath(Tankengines.name),
                #keyPath(Tankengines.price_gold),
                #keyPath(Tankengines.nation),
                #keyPath(Tankengines.power),
                #keyPath(Tankengines.price_credit),
                #keyPath(Tankengines.fire_starting_chance),
                #keyPath(Tankengines.module_id)]
    }
}

@objc extension Tankchassis {
    public static func keypaths() -> [String] {
        return [#keyPath(Tankchassis.name),
                #keyPath(Tankchassis.module_id),
                #keyPath(Tankchassis.max_load),
                #keyPath(Tankchassis.nation),
                #keyPath(Tankchassis.price_credit),
                #keyPath(Tankchassis.price_gold),
                #keyPath(Tankchassis.rotation_speed)]
    }
}

@objc extension Tankradios {
    public static func keypaths() -> [String] {
        return [#keyPath(Tankradios.name),
                #keyPath(Tankradios.module_id),
                #keyPath(Tankradios.distance),
                #keyPath(Tankradios.nation),
                #keyPath(Tankradios.price_credit),
                #keyPath(Tankradios.price_gold)]
    }
}

@objc extension Tankguns {
    public static func keypaths() -> [String] {
        return [#keyPath(Tankguns.name),
                #keyPath(Tankguns.module_id),
                #keyPath(Tankguns.nation),
                #keyPath(Tankguns.price_credit),
                #keyPath(Tankguns.price_gold),
                #keyPath(Tankguns.rate)]
    }
}

@objc extension Tankturrets {
    public static func keypaths() -> [String] {
        return [#keyPath(Tankturrets.name),
                #keyPath(Tankturrets.module_id),
                #keyPath(Tankturrets.nation),
                #keyPath(Tankturrets.armor_board),
                #keyPath(Tankturrets.armor_fedd),
                #keyPath(Tankturrets.armor_forehead),
                #keyPath(Tankturrets.circular_vision_radius),
                #keyPath(Tankturrets.price_credit),
                #keyPath(Tankturrets.price_gold),
                #keyPath(Tankturrets.rotation_speed)]
    }
}

@objc extension Vehicles {
    public static func keypaths() -> [String] {
        return [#keyPath(Vehicles.name),
                #keyPath(Vehicles.type),
                #keyPath(Vehicles.nation),
                #keyPath(Vehicles.tag),
                #keyPath(Vehicles.tier),
                #keyPath(Vehicles.tank_id),
                #keyPath(Vehicles.default_profile),
                #keyPath(Vehicles.modules_tree),
                #keyPath(Vehicles.engines),
                #keyPath(Vehicles.suspensions),
                #keyPath(Vehicles.radios),
                #keyPath(Vehicles.guns),
                #keyPath(Vehicles.turrets)]
    }
}

@objc extension VehicleprofileAmmo {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmo.ammoType)]
    }
}

@objc extension VehicleprofileAmmoDamage {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoDamage.avg_value),
                #keyPath(VehicleprofileAmmoDamage.max_value),
                #keyPath(VehicleprofileAmmoDamage.min_value)]
    }
}

@objc extension VehicleprofileEngine {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileEngine.name),
                #keyPath(VehicleprofileEngine.power),
                #keyPath(VehicleprofileEngine.weight),
                #keyPath(VehicleprofileEngine.tag),
                #keyPath(VehicleprofileEngine.fire_chance),
                #keyPath(VehicleprofileEngine.tier)]
    }
}

@objc extension VehicleprofileSuspension {

    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileSuspension.name),
                #keyPath(VehicleprofileSuspension.weight),
                #keyPath(VehicleprofileSuspension.load_limit),
                #keyPath(VehicleprofileSuspension.tag),
                #keyPath(VehicleprofileSuspension.tier)]
    }
}

@objc extension Vehicleprofile {
    public static func keypaths() -> [String] {
        return [#keyPath(Vehicleprofile.max_ammo),
                #keyPath(Vehicleprofile.weight),
                #keyPath(Vehicleprofile.hp),
                #keyPath(Vehicleprofile.is_default),
                #keyPath(Vehicleprofile.speed_forward),
                #keyPath(Vehicleprofile.hull_hp),
                #keyPath(Vehicleprofile.speed_backward),
                #keyPath(Vehicleprofile.tank_id),
                #keyPath(Vehicleprofile.max_weight)]
    }
}

@objc extension VehicleprofileRadio {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileRadio.tier),
                #keyPath(VehicleprofileRadio.signal_range),
                #keyPath(VehicleprofileRadio.tag),
                #keyPath(VehicleprofileRadio.weight),
                #keyPath(VehicleprofileRadio.name)]
    }
}

@objc extension VehicleprofileGun {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileGun.move_down_arc),
                #keyPath(VehicleprofileGun.caliber),
                #keyPath(VehicleprofileGun.name),
                #keyPath(VehicleprofileGun.weight),
                #keyPath(VehicleprofileGun.move_up_arc),
                #keyPath(VehicleprofileGun.fire_rate),
                #keyPath(VehicleprofileGun.dispersion),
                #keyPath(VehicleprofileGun.tag),
                #keyPath(VehicleprofileGun.reload_time),
                #keyPath(VehicleprofileGun.tier),
                #keyPath(VehicleprofileGun.aim_time)]
    }
}

@objc extension VehicleprofileTurret {
    public static func keypaths() -> [String] {
        return []
    }
}

@objc extension VehicleprofileAmmoPenetration {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoPenetration.avg_value),
                #keyPath(VehicleprofileAmmoPenetration.max_value),
                #keyPath(VehicleprofileAmmoPenetration.min_value)]
    }
}

@objc extension VehicleprofileArmor {
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileArmor.front),
                #keyPath(VehicleprofileArmor.sides),
                #keyPath(VehicleprofileArmor.rear)]
    }
}

/*
 TODO: Try KeyPathListable
 i.e. extension Vehiles:KeyPathListable {
      }
 */


protocol KeyPathListable {
    associatedtype AnyOldObject
    // require empty init as the implementation use the mirroring API, which require
    // to be used on an instance. So we need to be able to create a new instance of the
    // type. See @@@^^^@@@
    init()

    var keyPathReadableFormat: [String: Any] { get }
    var allKeyPaths: [String:KeyPath<AnyOldObject, Any?>] { get }
}


extension KeyPathListable {

    var keyPathReadableFormat: [String: Any] {
        var description: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            description[label] = value
        }
        return description
    }

    var allKeyPaths: [String:KeyPath<Self, Any?>] {
        var membersTokeyPaths: [String:KeyPath<Self, Any?>] = [:]
        let instance = Self() // @@@^^^@@@
        for (key, _) in instance.keyPathReadableFormat {
            membersTokeyPaths[key] = \Self.keyPathReadableFormat[key]
        }
        return membersTokeyPaths
    }

}

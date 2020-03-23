//
//  Tankengines+Keypath.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
extension ModulesTree: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(ModulesTree.name),
                #keyPath(ModulesTree.module_id),
                #keyPath(ModulesTree.price_credit),
                #keyPath(ModulesTree.next_guns),
                #keyPath(ModulesTree.next_tanks),
                #keyPath(ModulesTree.next_radios),
                #keyPath(ModulesTree.next_chassis),
                #keyPath(ModulesTree.next_engines),
                #keyPath(ModulesTree.next_modules),
                #keyPath(ModulesTree.next_turrets)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return ModulesTree.keypaths()
    }
}

@objc extension Tankengines: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankengines.name),
                #keyPath(Tankengines.price_gold),
                #keyPath(Tankengines.nation),
                #keyPath(Tankengines.power),
                #keyPath(Tankengines.price_credit),
                #keyPath(Tankengines.fire_starting_chance),
                #keyPath(Tankengines.module_id)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankengines.keypaths()
    }
}

@objc extension Tankchassis: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankchassis.name),
                #keyPath(Tankchassis.module_id),
                #keyPath(Tankchassis.max_load),
                #keyPath(Tankchassis.nation),
                #keyPath(Tankchassis.price_credit),
                #keyPath(Tankchassis.price_gold),
                #keyPath(Tankchassis.rotation_speed)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankchassis.keypaths()
    }
}

@objc extension Tankradios: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankradios.name),
                #keyPath(Tankradios.module_id),
                #keyPath(Tankradios.distance),
                #keyPath(Tankradios.nation),
                #keyPath(Tankradios.price_credit),
                #keyPath(Tankradios.price_gold)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankradios.keypaths()
    }
}

@objc extension Tankguns: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Tankguns.name),
                #keyPath(Tankguns.module_id),
                #keyPath(Tankguns.nation),
                #keyPath(Tankguns.price_credit),
                #keyPath(Tankguns.price_gold),
                #keyPath(Tankguns.rate)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankguns.keypaths()
    }
}

@objc extension Tankturrets: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
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

    @objc
    public func instanceKeypaths() -> [String] {
        return Tankturrets.keypaths()
    }
}

@objc extension Vehicles: KeypathProtocol {
    @objc
    public class func keypathsLight() -> [String] {
        return [#keyPath(Vehicles.name),
                #keyPath(Vehicles.short_name),
                #keyPath(Vehicles.type),
                #keyPath(Vehicles.nation),
                #keyPath(Vehicles.tag),
                #keyPath(Vehicles.tier),
                #keyPath(Vehicles.tank_id)
        ]
    }

    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Vehicles.name),
                #keyPath(Vehicles.short_name),
                #keyPath(Vehicles.is_premium),
                #keyPath(Vehicles.is_gift),
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

    @objc
    public func instanceKeypaths() -> [String] {
        return Vehicles.keypaths()
    }
}

@objc extension VehicleprofileAmmo: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmo.type)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmo.keypaths()
    }
}

@objc extension VehicleprofileAmmoDamage: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoDamage.avg_value),
                #keyPath(VehicleprofileAmmoDamage.max_value),
                #keyPath(VehicleprofileAmmoDamage.min_value)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmoDamage.keypaths()
    }
}

@objc extension VehicleprofileEngine: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileEngine.name),
                #keyPath(VehicleprofileEngine.power),
                #keyPath(VehicleprofileEngine.weight),
                #keyPath(VehicleprofileEngine.tag),
                #keyPath(VehicleprofileEngine.fire_chance),
                #keyPath(VehicleprofileEngine.tier)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileEngine.keypaths()
    }
}

@objc extension VehicleprofileSuspension: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileSuspension.name),
                #keyPath(VehicleprofileSuspension.weight),
                #keyPath(VehicleprofileSuspension.load_limit),
                #keyPath(VehicleprofileSuspension.tag),
                #keyPath(VehicleprofileSuspension.tier)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileSuspension.keypaths()
    }
}

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

@objc extension VehicleprofileRadio: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileRadio.tier),
                #keyPath(VehicleprofileRadio.signal_range),
                #keyPath(VehicleprofileRadio.tag),
                #keyPath(VehicleprofileRadio.weight),
                #keyPath(VehicleprofileRadio.name)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileRadio.keypaths()
    }
}

@objc extension VehicleprofileGun: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
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

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileGun.keypaths()
    }
}

@objc extension VehicleprofileTurret: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return []
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileTurret.keypaths()
    }
}

@objc extension VehicleprofileAmmoPenetration: KeypathProtocol {
    @objc
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoPenetration.avg_value),
                #keyPath(VehicleprofileAmmoPenetration.max_value),
                #keyPath(VehicleprofileAmmoPenetration.min_value)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmoPenetration.keypaths()
    }
}

@objc extension VehicleprofileArmor: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileArmor.front),
                #keyPath(VehicleprofileArmor.sides),
                #keyPath(VehicleprofileArmor.rear)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileArmor.keypaths()
    }
}

#warning("Try KeyPathListable; //extension Vehiles:KeyPathListable {}")

protocol KeyPathListable {
    associatedtype AnyOldObject
    // require empty init as the implementation use the mirroring API, which require
    // to be used on an instance. So we need to be able to create a new instance of the
    // type. See @@@^^^@@@
    init()

    var keyPathReadableFormat: [String: Any] { get }
    var allKeyPaths: [String: KeyPath<AnyOldObject, Any?>] { get }
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

    var allKeyPaths: [String: KeyPath<Self, Any?>] {
        var membersTokeyPaths: [String: KeyPath<Self, Any?>] = [:]
        let instance = Self() // @@@^^^@@@
        for (key, _) in instance.keyPathReadableFormat {
            membersTokeyPaths[key] = \Self.keyPathReadableFormat[key]
        }
        return membersTokeyPaths
    }
}

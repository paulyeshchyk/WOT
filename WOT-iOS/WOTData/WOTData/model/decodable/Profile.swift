//
//  JProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {
    
    @objc
    public class Profile: NSObject, Codable {
        private var ammo: [ProfileAmmo]?
        private var armor: ProfileArmor?
        private var engine: ProfileEngine?
        private var gun: ProfileGun?
        private var hp: Int?
        private var hull_hp: Int?
        private var hull_weight: Int?
        private var max_ammo: Int?
        private var max_weight: Int?
        private var modules: ProfileModules?
        private var radio: ProfileRadio?
        private var speed_backward: Int?
        private var speed_forward: Int?
        private var suspension: ProfileSuspension?
        private var turret: ProfileTurret?
        private var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case ammo
            case armor
            case engine
            case gun
            case hp
            case hull_hp
            case hull_weight
            case max_ammo
            case max_weight
            case modules
            case radio
            case speed_backward
            case speed_forward
            case suspension
            case turret
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            ammo = try container.decodeIfPresent(.ammo)
            armor = try container.decodeIfPresent(.armor)
            engine = try container.decodeIfPresent(.engine)
            gun = try container.decodeIfPresent(.gun)
            hp = try container.decodeIfPresent(.hp)
            hull_hp = try container.decodeIfPresent(.hull_hp)
            hull_weight = try container.decodeIfPresent(.hull_weight)
            max_ammo = try container.decodeIfPresent(.max_ammo)
            max_weight = try container.decodeIfPresent(.max_weight)
            modules = try container.decodeIfPresent(.modules)
            radio = try container.decodeIfPresent(.radio)
            speed_backward = try container.decodeIfPresent(.speed_backward)
            speed_forward = try container.decodeIfPresent(.speed_forward)
            suspension = try container.decodeIfPresent(.suspension)
            turret = try container.decodeIfPresent(.turret)
            weight = try container.decodeIfPresent(.weight)

        }
    }
}

//
//  JProfileAmmo.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    public enum AmmoType: String, Codable {
        case armor_piercing = "ARMOR_PIERCING"
        case hollow_charge = "HOLLOW_CHARGE"
        case high_explosive = "HIGH_EXPLOSIVE"
    }

    @objc
    public class ProfileAmmo: NSObject, Codable {
        private var damage: [Int]
        private var penetration: [Int]
        private var type: AmmoType

        private enum CodingKeys: String, CodingKey {
            case damage
            case penetration
            case type
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            damage = try container.decode(.damage)
            penetration = try container.decode(.penetration)
            type = try container.decode(.type)
        }
    }
}

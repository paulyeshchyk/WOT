//
//  JProfileArmor.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    @objc
    public class ProfileArmor: NSObject, Codable {
        private var hull: Armor
        private var turret: Armor

        private enum CodingKeys: String, CodingKey {
            case hull
            case turret
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            hull = try container.decode(.hull)
            turret = try container.decode(.turret)
        }
    }

    @objc
    public class Armor: NSObject, Codable {
        private var front: Int
        private var rear: Int
        private var sides: Int

        private enum CodingKeys: String, CodingKey {
            case front
            case rear
            case sides
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            front = try container.decode(.front)
            rear = try container.decode(.rear)
            sides = try container.decode(.sides)
        }
    }
}

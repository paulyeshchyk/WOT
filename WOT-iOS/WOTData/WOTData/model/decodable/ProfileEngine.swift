//
//  JProfileEngine.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {
    
    @objc
    public class ProfileEngine: NSObject, Codable {
        private var fire_chance: Float?
        private var name: String?
        private var power: Int?
        private var tag: String?
        private var tier: Tier?
        private var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case fire_chance
            case name
            case power
            case tag
            case tier
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            fire_chance = try container.decodeIfPresent(.fire_chance)
            name = try container.decodeIfPresent(.name)
            power = try container.decodeIfPresent(.power)
            tag = try container.decodeIfPresent(.tag)
            tier = try container.decodeIfPresent(.tier)
            weight = try container.decodeIfPresent(.weight)
        }
    }
}

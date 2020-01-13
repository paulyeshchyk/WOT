//
//  JProfileTurret.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {
    
    @objc
    public class ProfileTurret: NSObject, Codable {

        var hp: Int?
        var name: String?
        var tag: String?
        var tier: Tier?
        var traverse_left_arc: Int?
        var traverse_right_arc: Int?
        var traverse_speed: Int?
        var view_range: Int?
        var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case hp
            case name
            case tag
            case tier
            case traverse_left_arc
            case traverse_right_arc
            case traverse_speed
            case view_range
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            hp = try container.decodeIfPresent(.hp)
            tag = try container.decodeIfPresent(.tag)
            tier = try container.decodeIfPresent(.tier)
            name = try container.decodeIfPresent(.name)
            traverse_left_arc = try container.decodeIfPresent(.traverse_left_arc)
            traverse_right_arc = try container.decodeIfPresent(.traverse_right_arc)
            traverse_speed = try container.decodeIfPresent(.traverse_speed)
            view_range = try container.decodeIfPresent(.view_range)
            weight = try container.decodeIfPresent(.weight)
        }
    }

}

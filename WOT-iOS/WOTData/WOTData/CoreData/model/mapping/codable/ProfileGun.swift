//
//  JProfileGun.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {
    
    @objc
    public class ProfileGun: NSObject, Codable {
        private var aim_time: Float?
        private var caliber: Int?
        private var dispersion: Float?
        private var fire_rate: Float?
        private var move_down_arc: Int?
        private var move_up_arc: Int?
        private var name: String?
        private var reload_time: Float?
        private var tag: String?
        private var tier: Tier?
        private var traverse_speed: Int?
        private var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case aim_time
            case caliber
            case dispersion
            case fire_rate
            case move_down_arc
            case move_up_arc
            case name
            case reload_time
            case tag
            case tier
            case traverse_speed
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            aim_time = try container.decodeIfPresent(.aim_time)
            caliber = try container.decodeIfPresent(.caliber)
            dispersion = try container.decodeIfPresent(.dispersion)
            fire_rate = try container.decodeIfPresent(.fire_rate)
            move_down_arc = try container.decodeIfPresent(.move_down_arc)
            move_up_arc = try container.decodeIfPresent(.move_down_arc)
            name = try container.decodeIfPresent(.name)
            reload_time = try container.decodeIfPresent(.reload_time)
            tag = try container.decodeIfPresent(.tag)
            tier = try container.decodeIfPresent(.tier)
            traverse_speed = try container.decodeIfPresent(.traverse_speed)
            weight = try container.decodeIfPresent(.weight)

        }
    }
}

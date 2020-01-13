//
//  JProfileSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {
    
    @objc
    public class ProfileSuspension: NSObject, Codable {

        var load_limit: Int?
        var name: String?
        var steering_lock_angle: Int?
        var tag: String?
        var tier: Tier?
        var traverse_speed: Int?
        var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case load_limit
            case name
            case steering_lock_angle
            case tag
            case tier
            case traverse_speed
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            load_limit = try container.decodeIfPresent(.load_limit)
            name = try container.decodeIfPresent(.name)
            steering_lock_angle = try container.decodeIfPresent(.steering_lock_angle)
            tag = try container.decodeIfPresent(.tag)
            tier = try container.decodeIfPresent(.tier)
            traverse_speed = try container.decodeIfPresent(.traverse_speed)
            weight = try container.decodeIfPresent(.weight)
        }
    }
}

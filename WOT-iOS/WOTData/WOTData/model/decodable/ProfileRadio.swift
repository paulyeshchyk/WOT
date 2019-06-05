//
//  JProfileRadio.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    @objc
    public class ProfileRadio: NSObject, Codable {
        private var name: String?
        private var signal_range: Int?
        private var tag: String?
        private var tier: Tier?
        private var weight: Int?

        private enum CodingKeys: String, CodingKey {
            case name
            case signal_range
            case tag
            case tier
            case weight
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decodeIfPresent(.name)
            signal_range = try container.decodeIfPresent(.signal_range)
            tag = try container.decodeIfPresent(.tag)
            tier = try container.decodeIfPresent(.tier)
            weight = try container.decodeIfPresent(.weight)

        }
    }
}

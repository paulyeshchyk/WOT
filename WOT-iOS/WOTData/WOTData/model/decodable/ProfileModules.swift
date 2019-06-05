//
//  ModulesPOJO.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    @objc
    public class ProfileModules: NSObject, Codable {
        private var engine_id: Int?
        private var gun_id: Int?
        private var radio_id: Int?
        private var suspension_id: Int?
        private var turret_id: Int?

        private enum CodingKeys: String, CodingKey {
            case engine_id
            case gun_id
            case radio_id
            case suspension_id
            case turret_id
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            engine_id = try container.decodeIfPresent(.engine_id)
            gun_id = try container.decodeIfPresent(.gun_id)
            radio_id = try container.decodeIfPresent(.radio_id)
            suspension_id = try container.decodeIfPresent(.suspension_id)
            turret_id = try container.decodeIfPresent(.turret_id)
        }
    }
}

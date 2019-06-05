//
//  JVehicle.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    public class Vehicle: Codable {
        
        private enum CodingKeys: String, CodingKey {
            case default_profile
            case engines
            case guns
            case modules_tree
            case name
            case nation
            case radios
            case suspensions
            case tag
            case tank_id
            case tier
            case turrets
            case type
        }
        
        private var default_profile: Profile?
        private var engines: [Int]?
        private var guns: [Int]?
        private var modules_tree: [String: ModulesTree]?
        private var name: String?
        private var nation: String?
        private var radios: [Int]?
        private var suspensions: [Int]?
        private var tag: String?
        private var tank_id: Int?
        private var tier: Tier?
        private var turrets: [Int]?
        private var type: VehicleType?

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            default_profile = try container.decodeIfPresent(.default_profile)
            engines = try container.decodeIfPresent(.engines)
            guns = try container.decodeIfPresent(.guns)
            modules_tree = try container.decodeIfPresent(.modules_tree)

            name = try container.decodeIfPresent(.name)
            nation = try container.decodeIfPresent(.nation)
            radios = try container.decodeIfPresent(.radios)
            suspensions = try container.decodeIfPresent(.suspensions)
            tag = try container.decodeIfPresent(.tag)
            tank_id = try container.decodeIfPresent(.tank_id)
            tier = try container.decodeIfPresent(.tier)
            turrets = try container.decodeIfPresent(.turrets)
            type = try container.decodeIfPresent(.type)
        }
    }
}

//
//  JProfileModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTPivot

extension WebLayer {

    public class ModulesTree: Codable {
        private var is_default: Bool?
        private var module_id: Int?
        private var name: String?
        private var next_modules: [Int]?
        private var next_tanks: [Int]?
        private var price_credit: Int?
        private var price_xp: Int?
        private var type: ModuleType?
        
        private enum CodingKeys: String, CodingKey {
            case is_default
            case module_id
            case name
            case next_modules
            case next_tanks
            case price_credit
            case price_xp
            case type
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            is_default = try container.decodeIfPresent(.is_default)
            module_id = try container.decodeIfPresent(.module_id)
            name = try container.decodeIfPresent(.name)
            next_modules = try container.decodeIfPresent(.next_modules)
            next_tanks = try container.decodeIfPresent(.next_tanks)
            price_credit = try container.decodeIfPresent(.price_credit)
            price_xp = try container.decodeIfPresent(.price_xp)
            type = try container.decodeIfPresent(.type)
        }
    }
}

//
//  Vehicles+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension Vehicles: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case is_gift
        case is_premium
        case is_premium_igr
        case is_wheeled
        case name
        case nation
        case price_credit
        case price_gold
        case short_name
        case tag
        case tank_id
        case tier
        case type
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case default_profile
        case engines
        case guns
        case radios
        case modules_tree
        case suspensions
        case turrets
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        name = try container.decodeIfPresent(String.self, forKey: .name)
        short_name = try container.decodeIfPresent(String.self, forKey: .short_name)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        tag = try container.decodeIfPresent(String.self, forKey: .tag)
        tank_id = try container.decodeIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        nation = try container.decodeIfPresent(String.self, forKey: .nation)
        price_credit = try container.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        price_gold = try container.decodeIfPresent(Int.self, forKey: .price_gold)?.asDecimal
        is_premium = try container.decodeIfPresent(Bool.self, forKey: .is_premium)?.asDecimal
        is_premium_igr = try container.decodeIfPresent(Bool.self, forKey: .is_premium_igr)?.asDecimal
        is_gift = try container.decodeIfPresent(Bool.self, forKey: .is_gift)?.asDecimal
        if let set = modules_tree {
            removeFromModules_tree(set)
        }
    }
}

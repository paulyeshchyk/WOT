//
//  Vehicles+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension Vehicles: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
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
    }
}

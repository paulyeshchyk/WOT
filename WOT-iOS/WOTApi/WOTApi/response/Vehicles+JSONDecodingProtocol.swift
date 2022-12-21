//
//  Vehicles+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension Vehicles: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.short_name = try container.decodeIfPresent(String.self, forKey: .short_name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.tag = try container.decodeIfPresent(String.self, forKey: .tag)
        self.tank_id = try container.decodeIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        self.nation = try container.decodeIfPresent(String.self, forKey: .nation)
        self.price_credit = try container.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_gold = try container.decodeIfPresent(Int.self, forKey: .price_gold)?.asDecimal
        self.is_premium = try container.decodeIfPresent(Bool.self, forKey: .is_premium)?.asDecimal
        self.is_premium_igr = try container.decodeIfPresent(Bool.self, forKey: .is_premium_igr)?.asDecimal
        self.is_gift = try container.decodeIfPresent(Bool.self, forKey: .is_gift)?.asDecimal
    }
}

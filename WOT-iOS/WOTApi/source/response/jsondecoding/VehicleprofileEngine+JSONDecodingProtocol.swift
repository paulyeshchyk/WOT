//
//  VehicleprofileEngine+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileEngine: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        fire_chance = try container.decodeAnyIfPresent(Double.self, forKey: .fire_chance)?.asDecimal
        power = try container.decodeAnyIfPresent(Int.self, forKey: .power)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
    }
}

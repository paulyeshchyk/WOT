//
//  VehicleprofileTurret+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileTurret: DecodableProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        view_range = try container.decodeAnyIfPresent(Int.self, forKey: .view_range)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        traverse_left_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_left_arc)?.asDecimal
        traverse_right_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_right_arc)?.asDecimal
        traverse_speed = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_speed)?.asDecimal
        hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
    }
}

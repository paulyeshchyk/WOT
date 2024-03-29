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
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case traverse_left_arc
        case traverse_speed
        case weight
        case view_range
        case hp
        case tier
        case name
        case tag
        case traverse_right_arc
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
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

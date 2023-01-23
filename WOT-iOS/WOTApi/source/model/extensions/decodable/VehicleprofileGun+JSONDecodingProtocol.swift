//
//  VehicleprofileGun+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileGun: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        caliber = try container.decodeAnyIfPresent(Int.self, forKey: .caliber)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        move_down_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_down_arc)?.asDecimal
        move_up_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_up_arc)?.asDecimal
        fire_rate = try container.decodeAnyIfPresent(Double.self, forKey: .fire_rate)?.asDecimal
        dispersion = try container.decodeAnyIfPresent(Double.self, forKey: .dispersion)?.asDecimal
        reload_time = try container.decodeAnyIfPresent(Double.self, forKey: .reload_time)?.asDecimal
        aim_time = try container.decodeAnyIfPresent(Double.self, forKey: .aim_time)?.asDecimal
    }
}

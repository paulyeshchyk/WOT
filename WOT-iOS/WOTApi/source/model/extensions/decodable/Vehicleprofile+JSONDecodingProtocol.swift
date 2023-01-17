//
//  Vehicleprofile+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension Vehicleprofile: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case modules
        case modulesTree
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        tank_id = try container.decodeAnyIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        is_default = try container.decodeAnyIfPresent(Bool.self, forKey: .is_default)?.asDecimal
        max_ammo = try container.decodeAnyIfPresent(Int.self, forKey: .max_ammo)?.asDecimal
        max_weight = try container.decodeAnyIfPresent(Int.self, forKey: .max_weight)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
        hull_hp = try container.decodeAnyIfPresent(Int.self, forKey: .hull_hp)?.asDecimal
        hull_weight = try container.decodeAnyIfPresent(Int.self, forKey: .hull_weight)?.asDecimal
        speed_backward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_backward)?.asDecimal
        speed_forward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_forward)?.asDecimal
    }
}

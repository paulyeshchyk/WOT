//
//  Module+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension Module: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case name
        case nation
        case tier
        case type
        case price_credit
        case weight
        case image
        case module_id
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case tanks
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        module_id = try container.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nation = try container.decodeIfPresent(String.self, forKey: .nation)
        tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        type = try container.decodeIfPresent(String.self, forKey: .type)
        price_credit = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        weight = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}

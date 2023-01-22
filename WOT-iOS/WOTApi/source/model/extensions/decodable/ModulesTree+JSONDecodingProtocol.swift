//
//  ModulesTree+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension ModulesTree: DecodableProtocol {

    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case default_profile
        case next_modules
        case next_tanks
        case currentModule
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let fieldsContainer = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        name = try fieldsContainer.decodeIfPresent(String.self, forKey: .name)
        type = try fieldsContainer.decodeIfPresent(String.self, forKey: .type)
        module_id = try fieldsContainer.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        price_credit = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        price_xp = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_xp)?.asDecimal
        is_default = try fieldsContainer.decodeIfPresent(Bool.self, forKey: .is_default)?.asDecimal
    }
}

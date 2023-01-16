//
//  VehicleprofileRadio+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileRadio: DecodableProtocol {
    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: Fields.self)
        //
        name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        signal_range = try container.decodeAnyIfPresent(Int.self, forKey: .signal_range)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
    }
}

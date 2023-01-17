//
//  VehicleprofileAmmo+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileAmmo: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case type
        case stun
        case damage
        case penetration
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let container = try decoder.container(keyedBy: DataFieldsKeys.self)
        //
        type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}

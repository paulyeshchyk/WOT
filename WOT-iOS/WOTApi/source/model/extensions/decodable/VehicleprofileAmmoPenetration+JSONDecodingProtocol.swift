//
//  VehicleprofileAmmoPenetration+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - VehicleprofileAmmoPenetration + DecodableProtocol

extension VehicleprofileAmmoPenetration: DecodableProtocol {
    //
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case min_value
        case avg_value
        case max_valie
    }

    public func decodeWith(_ decoder: DecoderObjC) throws {
        guard let decoder = decoder as? Decoder else {
            throw DecodableProtocolErrors.notADecoder
        }
        let damage = try MinAvgMax(from: decoder)

        min_value = damage.min_value as? NSDecimalNumber
        avg_value = damage.avg_value as? NSDecimalNumber
        max_value = damage.max_value as? NSDecimalNumber
    }
}

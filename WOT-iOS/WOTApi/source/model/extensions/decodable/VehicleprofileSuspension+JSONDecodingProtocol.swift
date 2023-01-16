//
//  VehicleprofileSuspension+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileSuspension: DecodableProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        load_limit = try container.decodeAnyIfPresent(Int.self, forKey: .load_limit)?.asDecimal
        steering_lock_angle = try container.decodeAnyIfPresent(Int.self, forKey: .steering_lock_angle)?.asDecimal
    }
}

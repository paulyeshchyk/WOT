//
//  VehicleprofileModule+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileModule: DecodableProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        radio_id = try container.decodeAnyIfPresent(Int.self, forKey: .radio_id)?.asDecimal
        suspension_id = try container.decodeAnyIfPresent(Int.self, forKey: .suspension_id)?.asDecimal
        engine_id = try container.decodeAnyIfPresent(Int.self, forKey: .engine_id)?.asDecimal
        gun_id = try container.decodeAnyIfPresent(Int.self, forKey: .gun_id)?.asDecimal
        turret_id = try container.decodeAnyIfPresent(Int.self, forKey: .turret_id)?.asDecimal
    }
}

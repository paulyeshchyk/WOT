//
//  VehicleprofileModule+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension VehicleprofileModule: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.radio_id = try container.decodeAnyIfPresent(Int.self, forKey: .radio_id)?.asDecimal
        self.suspension_id = try container.decodeAnyIfPresent(Int.self, forKey: .suspension_id)?.asDecimal
        self.engine_id = try container.decodeAnyIfPresent(Int.self, forKey: .engine_id)?.asDecimal
        self.gun_id = try container.decodeAnyIfPresent(Int.self, forKey: .gun_id)?.asDecimal
        self.turret_id = try container.decodeAnyIfPresent(Int.self, forKey: .turret_id)?.asDecimal
    }
}

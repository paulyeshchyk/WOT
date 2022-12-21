//
//  Vehicleprofile+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension Vehicleprofile: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.tank_id = try container.decodeAnyIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        self.is_default = try container.decodeAnyIfPresent(Bool.self, forKey: .is_default)?.asDecimal
        self.max_ammo = try container.decodeAnyIfPresent(Int.self, forKey: .max_ammo)?.asDecimal
        self.max_weight = try container.decodeAnyIfPresent(Int.self, forKey: .max_weight)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
        self.hull_hp = try container.decodeAnyIfPresent(Int.self, forKey: .hull_hp)?.asDecimal
        self.hull_weight = try container.decodeAnyIfPresent(Int.self, forKey: .hull_weight)?.asDecimal
        self.speed_backward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_backward)?.asDecimal
        self.speed_forward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_forward)?.asDecimal
    }
}

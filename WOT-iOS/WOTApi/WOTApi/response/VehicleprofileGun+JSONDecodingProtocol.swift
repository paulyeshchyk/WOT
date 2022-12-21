//
//  VehicleprofileGun+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension VehicleprofileGun: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.caliber = try container.decodeAnyIfPresent(Int.self, forKey: .caliber)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.move_down_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_down_arc)?.asDecimal
        self.move_up_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_up_arc)?.asDecimal
        self.fire_rate = try container.decodeAnyIfPresent(Double.self, forKey: .fire_rate)?.asDecimal
        self.dispersion = try container.decodeAnyIfPresent(Double.self, forKey: .dispersion)?.asDecimal
        self.reload_time = try container.decodeAnyIfPresent(Double.self, forKey: .reload_time)?.asDecimal
        self.aim_time = try container.decodeAnyIfPresent(Double.self, forKey: .aim_time)?.asDecimal
    }
}

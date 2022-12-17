//
//  VehicleprofileEngine+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONDecodingProtocol

extension VehicleprofileEngine: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.fire_chance = try container.decodeAnyIfPresent(Double.self, forKey: .fire_chance)?.asDecimal
        self.power = try container.decodeAnyIfPresent(Int.self, forKey: .power)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
    }
}

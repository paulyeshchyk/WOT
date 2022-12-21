//
//  VehicleprofileTurret+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension VehicleprofileTurret: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.view_range = try container.decodeAnyIfPresent(Int.self, forKey: .view_range)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.traverse_left_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_left_arc)?.asDecimal
        self.traverse_right_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_right_arc)?.asDecimal
        self.traverse_speed = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_speed)?.asDecimal
        self.hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
    }
}

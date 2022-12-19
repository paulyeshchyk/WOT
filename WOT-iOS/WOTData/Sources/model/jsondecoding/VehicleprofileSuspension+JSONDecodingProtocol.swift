//
//  VehicleprofileSuspension+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension VehicleprofileSuspension: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.load_limit = try container.decodeAnyIfPresent(Int.self, forKey: .load_limit)?.asDecimal
        self.steering_lock_angle = try container.decodeAnyIfPresent(Int.self, forKey: .steering_lock_angle)?.asDecimal
    }
}

//
//  VehicleprofileArmor+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension VehicleprofileArmor: DecodableProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        front = try container.decodeAnyIfPresent(Int.self, forKey: .front)?.asDecimal
        sides = try container.decodeAnyIfPresent(Int.self, forKey: .sides)?.asDecimal
        rear = try container.decodeAnyIfPresent(Int.self, forKey: .rear)?.asDecimal
    }
}

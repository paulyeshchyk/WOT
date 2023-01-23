//
//  Module+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - JSONDecodingProtocol

extension Module: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.module_id = try container.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nation = try container.decodeIfPresent(String.self, forKey: .nation)
        self.tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.price_credit = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.weight = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}

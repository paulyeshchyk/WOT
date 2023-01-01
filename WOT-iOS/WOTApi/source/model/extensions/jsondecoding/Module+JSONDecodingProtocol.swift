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
        module_id = try container.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        name = try container.decodeIfPresent(String.self, forKey: .name)
        nation = try container.decodeIfPresent(String.self, forKey: .nation)
        tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        type = try container.decodeIfPresent(String.self, forKey: .type)
        price_credit = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        weight = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}

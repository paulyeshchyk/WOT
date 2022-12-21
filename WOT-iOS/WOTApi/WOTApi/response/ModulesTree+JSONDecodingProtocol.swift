//
//  ModulesTree+JSONDecodingProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - JSONDecodingProtocol

extension ModulesTree: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let fieldsContainer = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try fieldsContainer.decodeIfPresent(String.self, forKey: .name)
        self.type = try fieldsContainer.decodeIfPresent(String.self, forKey: .type)
        self.module_id = try fieldsContainer.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.price_credit = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_xp = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_xp)?.asDecimal
        self.is_default = try fieldsContainer.decodeIfPresent(Bool.self, forKey: .is_default)?.asDecimal
    }
}

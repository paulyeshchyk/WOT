//
//  JSONDecoding.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

class DecoderWrapper: Decodable {
    let decoder: Decoder

    required init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}

protocol JSONDecoding {
    func decodeWith(_ decoder: Decoder) throws
}

extension JSONDecoding where Self: NSManagedObject {
    func decode(json: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        try decodeWith(wrapper.decoder)
    }
}

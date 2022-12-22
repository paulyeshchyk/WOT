//
//  NSManagedObject+JSONDecoding.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension JSONDecodingProtocol where Self: NSManagedObject {
    public func decode(json: JSON) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        try decodeWith(wrapper.decoder)
    }

    public func decode(array: [Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        try decodeWith(wrapper.decoder)
    }
    
    public func decodeWith(_ decoder: Decoder) throws {
        
    }

}

class DecoderWrapper: Decodable {
    let decoder: Decoder

    required init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}

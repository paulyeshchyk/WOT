//
//  DecoderContainer.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol DecoderContainer {
    func decoder() throws -> Decoder
}

extension Array: DecoderContainer {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

extension JSON: DecoderContainer {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}


class DecoderWrapper: Decodable {
    let decoder: Decoder

    required init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}

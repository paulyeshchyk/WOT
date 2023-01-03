//
//  DecoderContainer.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

// MARK: - DecoderContainer

public protocol DecoderContainer {
    func decoder() throws -> Decoder
}

// MARK: - Array + DecoderContainer

extension Array: DecoderContainer {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

// MARK: - JSON + DecoderContainer

extension JSON: DecoderContainer {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

// MARK: - DecoderWrapper

class DecoderWrapper: Decodable {

    required init(from decoder: Decoder) throws {
        self.decoder = decoder
    }

    let decoder: Decoder
}

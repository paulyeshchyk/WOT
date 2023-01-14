//
//  DecoderContainer.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

// MARK: - DecoderContainerProtocol

public protocol DecoderContainerProtocol {
    func decoder() throws -> Decoder
}

// MARK: - Array + DecoderContainerProtocol

extension Array: DecoderContainerProtocol {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

// MARK: - JSON + DecoderContainerProtocol

extension JSON: DecoderContainerProtocol {
    public func decoder() throws -> Decoder {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}

// MARK: - DecoderWrapper

class DecoderWrapper: Decodable {

    let decoder: Decoder

    // MARK: Lifecycle

    required init(from decoder: Decoder) throws {
        self.decoder = decoder
    }

}

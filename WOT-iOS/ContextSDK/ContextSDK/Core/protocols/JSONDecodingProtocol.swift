//
//  JSONDecodingProtocol.swift
//  ContextSDK
//
//  Created by Paul on 24.12.22.
//

public protocol JSONDecodingProtocol {
    func decodeWith(_ decoder: Decoder) throws
}

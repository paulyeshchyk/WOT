//
//  DecoderManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - DecoderManagerProtocol

@objc
public protocol DecoderManagerProtocol {
    func register(jsonDecoder: JSONDecoderProtocol.Type, for modelClass: PrimaryKeypathProtocol.Type)
    func jsonDecoder(for modelClass: PrimaryKeypathProtocol.Type) -> JSONDecoderProtocol.Type?
}

// MARK: - DecoderManagerContainerProtocol

@objc
public protocol DecoderManagerContainerProtocol {
    var decoderManager: DecoderManagerProtocol? { get set }
}

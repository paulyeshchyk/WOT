//
//  DecoderManager.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

open class DecoderManager: DecoderManagerProtocol {

    private var list: [AnyHashable: JSONDecoderProtocol.Type] = [:]

    public init() {
        //
    }

    public func register(jsonDecoder: JSONDecoderProtocol.Type, for modelClass: PrimaryKeypathProtocol.Type) {
        list[String(describing: modelClass)] = jsonDecoder
    }

    public func jsonDecoder(for modelClass: PrimaryKeypathProtocol.Type) -> JSONDecoderProtocol.Type? {
        return list[String(describing: modelClass)]
    }
}

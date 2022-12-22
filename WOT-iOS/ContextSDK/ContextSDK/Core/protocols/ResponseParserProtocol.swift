//
//  ResponseParserContainerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseParserContainerProtocol {
    @objc var responseParser: WOTResponseParserProtocol? { get set }
}

@objc
public protocol WOTResponseParserProtocol {
    func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, adapters: [DataAdapterProtocol], onParseComplete: @escaping OnParseComplete) throws
}

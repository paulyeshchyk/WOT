//
//  ResponseParserContainerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseParserContainerProtocol {
    var responseParser: ResponseParserProtocol? { get set }
}

@objc
public protocol ResponseParserProtocol {
    func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, adapters: [DataAdapterProtocol]?, completion: @escaping DataAdapterProtocol.OnComplete) throws
}

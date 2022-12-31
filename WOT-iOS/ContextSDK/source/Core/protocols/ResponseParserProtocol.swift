//
//  ResponseParserContainerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol ResponseParserProtocol {
    typealias Context = LogInspectorContainerProtocol
    //
    init(appContext: ResponseParserProtocol.Context)
    func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, dataAdapter: ResponseAdapterProtocol?, completion: @escaping ResponseAdapterProtocol.OnComplete) throws
}

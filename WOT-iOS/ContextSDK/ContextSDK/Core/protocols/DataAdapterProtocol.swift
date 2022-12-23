//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias OnParseComplete = (RequestProtocol?, Error?) -> Void

public protocol DataAdapterProtocol {
    func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: RequestProtocol, completion: OnParseComplete?) where T: RESTAPIResponseProtocol
}

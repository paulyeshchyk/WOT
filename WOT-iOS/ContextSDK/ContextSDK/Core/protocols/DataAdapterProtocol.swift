//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public typealias OnParseComplete = (RequestProtocol?, Error?) -> Void

@objc
public protocol DataAdapterProtocol {
    var onJSONDidParse: OnParseComplete? { get set }
    func didFinishJSONDecoding(_ json: JSON?, fromRequest: RequestProtocol, _ error: Error?)
}

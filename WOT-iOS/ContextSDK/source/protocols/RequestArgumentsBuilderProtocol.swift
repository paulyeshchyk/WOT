//
//  RequestArgumentsBuilderProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - RequestArgumentsBuilderProtocol

@objc
public protocol RequestArgumentsBuilderProtocol: MD5Protocol {
    var modelClass: RequestableProtocol.Type { get }
    func buildRequestArguments(keypathPrefix: String?, httpQueryItemName: String?) -> RequestArguments
}

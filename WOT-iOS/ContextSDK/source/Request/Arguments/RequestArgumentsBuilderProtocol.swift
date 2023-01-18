//
//  RequestArgumentsBuilderProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - RequestArgumentsBuilderProtocol

@objc
public protocol RequestArgumentsBuilderProtocol: MD5Protocol {
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type
    var modelClass: ModelClassType { get }
    func buildRequestArguments(keypathPrefix: String?, httpQueryItemName: String?) -> RequestArguments
}

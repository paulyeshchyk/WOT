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
    var contextPredicate: ContextPredicateProtocol? { get set }
    var keypathPrefix: String? { get set }
    var httpQueryItemName: String? { get set }

    func build() -> RequestArguments
}

//
//  RequestParadigmProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - RequestArgumentsBuilderProtocol

@objc
public protocol RequestArgumentsBuilderProtocol {
    func buildRequestArguments(keypathPrefix: String?, httpQueryItemName: String?) -> RequestArguments
}

// MARK: - ContextPredicateBuilderProtocol

@objc
public protocol ContextPredicateBuilderProtocol {
    func buildContextPredicate() -> ContextPredicateProtocol
}

// MARK: - RequestParadigmProtocol

@objc
public protocol RequestParadigmProtocol: RequestArgumentsBuilderProtocol, ContextPredicateBuilderProtocol, MD5Protocol {
    var modelClass: RequestableProtocol.Type { get }
}

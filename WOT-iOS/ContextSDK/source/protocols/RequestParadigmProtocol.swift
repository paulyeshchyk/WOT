//
//  RequestParadigmProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - RequestArgumentsBuilder

@objc
public protocol RequestArgumentsBuilder {
    func buildRequestArguments() -> RequestArguments
}

// MARK: - ContextPredicateBuilder

@objc
public protocol ContextPredicateBuilder {
    func buildContextPredicate() -> ContextPredicateProtocol
}

// MARK: - RequestParadigmProtocol

@objc
public protocol RequestParadigmProtocol: RequestArgumentsBuilder, ContextPredicateBuilder, MD5Protocol {
    var modelClass: RequestableProtocol.Type { get }
}

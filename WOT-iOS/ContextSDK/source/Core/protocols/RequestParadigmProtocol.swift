//
//  RequestParadigmProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

@objc
public protocol RequestParadigmProtocol: MD5Protocol {
    var modelClass: RequestableProtocol.Type { get }
    func buildContextPredicate() throws -> ContextPredicateProtocol
    func buildRequestArguments() -> RequestArguments
}

//
//  FetchRequestPredicateComposerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - FetchRequestPredicateComposerProtocol

@objc
public protocol FetchRequestPredicateComposerProtocol: AnyObject {
    func buildRequestPredicateComposition() throws -> ContextPredicateProtocol
}

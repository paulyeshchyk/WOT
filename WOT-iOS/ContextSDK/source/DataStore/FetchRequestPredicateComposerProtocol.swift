//
//  FetchRequestPredicateComposerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - FetchRequestPredicateComposerProtocol

@objc
public protocol FetchRequestPredicateComposerProtocol: AnyObject {
    func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol
}

// MARK: - FetchRequestPredicateCompositionProtocol

@objc
public protocol FetchRequestPredicateCompositionProtocol: AnyObject {
    var objectIdentifier: Any? { get }
    var contextPredicate: ContextPredicateProtocol { get }
}

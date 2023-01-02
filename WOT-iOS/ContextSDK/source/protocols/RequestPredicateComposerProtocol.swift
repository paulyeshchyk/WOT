//
//  RequestPredicateComposerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

@objc
public protocol RequestPredicateComposerProtocol: AnyObject {
    func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol
}

@objc
public protocol RequestPredicateCompositionProtocol: AnyObject {
    var objectIdentifier: Any? { get }
    var contextPredicate: ContextPredicateProtocol { get }
}

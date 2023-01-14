//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class ForeignAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private var contextPredicate: ContextPredicateProtocol
    private var foreignSelectKey: String
    private let pins: [AnyObject]

    // MARK: Lifecycle

    public init(contextPredicate: ContextPredicateProtocol, foreignSelectKey: String, pins: [AnyObject]) {
        self.contextPredicate = contextPredicate
        self.foreignSelectKey = foreignSelectKey
        self.pins = pins
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(pins: pins)
        lookupPredicate[.primary] = contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}

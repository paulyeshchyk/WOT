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
    private let managedRefs: [ManagedRefProtocol]
    private let jsonRefs: [JSONRefProtocol]

    // MARK: Lifecycle

    public init(contextPredicate: ContextPredicateProtocol, foreignSelectKey: String, managedRefs: [ManagedRefProtocol], jsonRefs: [JSONRefProtocol]) {
        self.contextPredicate = contextPredicate
        self.foreignSelectKey = foreignSelectKey
        self.managedRefs = managedRefs
        self.jsonRefs = jsonRefs
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(managedRefs: managedRefs, jsonRefs: jsonRefs)
        lookupPredicate[.primary] = contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}

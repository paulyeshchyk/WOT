//
//  ForeignAsPrimaryAndForeignSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class ForeignAsPrimaryAndForeignSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private var requestPredicate: ContextPredicateProtocol
    private var foreignPrimarySelectKey: String
    private var foreignSecondarySelectKey: String

    public init(requestPredicate: ContextPredicateProtocol, foreignPrimarySelectKey: String, foreignSecondarySelectKey: String) {
        self.requestPredicate = requestPredicate
        self.foreignPrimarySelectKey = foreignPrimarySelectKey
        self.foreignSecondarySelectKey = foreignSecondarySelectKey
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignPrimarySelectKey)
        lookupPredicate[.secondary] = requestPredicate[.secondary]?.foreignKey(byInsertingComponent: foreignSecondarySelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
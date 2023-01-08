//
//  ForeignAsPrimaryAndForeignSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class ForeignAsPrimaryAndForeignSecondaryRuleBuilder: RequestPredicateComposerProtocol {

    public init(contextPredicate: ContextPredicateProtocol, foreignPrimarySelectKey: String, foreignSecondarySelectKey: String) {
        self.contextPredicate = contextPredicate
        self.foreignPrimarySelectKey = foreignPrimarySelectKey
        self.foreignSecondarySelectKey = foreignSecondarySelectKey
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignPrimarySelectKey)
        lookupPredicate[.secondary] = contextPredicate[.secondary]?.foreignKey(byInsertingComponent: foreignSecondarySelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

    private var contextPredicate: ContextPredicateProtocol
    private var foreignPrimarySelectKey: String
    private var foreignSecondarySelectKey: String
}

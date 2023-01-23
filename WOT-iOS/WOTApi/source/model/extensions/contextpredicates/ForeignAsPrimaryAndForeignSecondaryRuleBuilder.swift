//
//  ForeignAsPrimaryAndForeignSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class ForeignAsPrimaryAndForeignSecondaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private var jsonMap: JSONMapProtocol
    private var foreignPrimarySelectKey: String
    private var foreignSecondarySelectKey: String

    // MARK: Lifecycle

    public init(jsonMap: JSONMapProtocol, foreignPrimarySelectKey: String, foreignSecondarySelectKey: String) {
        self.jsonMap = jsonMap
        self.foreignPrimarySelectKey = foreignPrimarySelectKey
        self.foreignSecondarySelectKey = foreignSecondarySelectKey
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = jsonMap.contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignPrimarySelectKey)
        lookupPredicate[.secondary] = jsonMap.contextPredicate[.secondary]?.foreignKey(byInsertingComponent: foreignSecondarySelectKey)

        return FetchRequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}

//
//  ForeignAsPrimaryAndForeignSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class ForeignAsPrimaryAndForeignSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private var requestPredicate: RequestPredicate
    private var foreignPrimarySelectKey: String
    private var foreignSecondarySelectKey: String

    public init(requestPredicate: RequestPredicate, foreignPrimarySelectKey: String, foreignSecondarySelectKey: String) {
        self.requestPredicate = requestPredicate
        self.foreignPrimarySelectKey = foreignPrimarySelectKey
        self.foreignSecondarySelectKey = foreignSecondarySelectKey
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = RequestPredicate()
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignPrimarySelectKey)
        lookupPredicate[.secondary] = requestPredicate[.secondary]?.foreignKey(byInsertingComponent: foreignSecondarySelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}

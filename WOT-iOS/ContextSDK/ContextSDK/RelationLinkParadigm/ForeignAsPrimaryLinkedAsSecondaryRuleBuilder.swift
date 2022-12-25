//
//  ForeignAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class ForeignAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private var requestPredicate: ContextPredicate
    private var ammoType: AnyObject?
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var foreignSelectKey: String

    public init(requestPredicate: ContextPredicate, ammoType: AnyObject?, linkedClazz: PrimaryKeypathProtocol.Type, foreignSelectKey: String) {
        self.requestPredicate = requestPredicate
        self.linkedClazz = linkedClazz
        self.foreignSelectKey = foreignSelectKey
        self.ammoType = ammoType
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = linkedClazz.primaryKey(for: ammoType, andType: .internal)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}

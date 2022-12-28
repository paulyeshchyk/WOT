//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RootTagRuleBuilder: RequestPredicateComposerProtocol {
    private var json: JSON?
    private var linkedClazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, linkedClazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.linkedClazz = linkedClazz
    }

    public func build() -> RequestPredicateCompositionProtocol? {
        guard let json = self.json else { return nil }

        guard let idKeyPath = linkedClazz.primaryKeyPath(forType: .internal) else {
            return nil
        }
        let itemID = json[idKeyPath] as AnyObject

        let lookupPredicate = ContextPredicate()
        if let primaryID = linkedClazz.primaryKey(forType: .internal, andObject: itemID) {
            lookupPredicate[.primary] = primaryID
        }

        return RequestPredicateComposition(objectIdentifier: itemID, requestPredicate: lookupPredicate)
    }
}

//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class RootTagRuleBuilder: RequestPredicateComposerProtocol {
    private var json: JSON?
    private var linkedClazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, linkedClazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.linkedClazz = linkedClazz
    }

    public func build() -> RequestPredicateComposition? {
        guard let json = self.json else { return nil }

        let itemID: AnyObject?
        if let idKeyPath = linkedClazz.primaryKeyPath(forType: .internal) {
            itemID = json[idKeyPath] as AnyObject
        } else {
            itemID = nil
            fatalError("need to debug")
        }
        guard let itemID1 = itemID else { return nil }

        let lookupPredicate = RequestPredicate()
        if let primaryID = linkedClazz.primaryKey(for: itemID1, andType: .internal) {
            lookupPredicate[.primary] = primaryID
        }

        return RequestPredicateComposition(objectIdentifier: itemID, requestPredicate: lookupPredicate)
    }
}

//
//  LinkLookupRuleBuilderObjectID.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class LinkLookupRuleBuilderObjectID: LinkLookupRuleBuilderProtocol {
    private var json: JSON?
    private var clazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, linkedClazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.clazz = linkedClazz
    }

    public func build() -> LinkLookupRule? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase()
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: .internal) {
            itemID = json[idKeyPath]
        } else {
            itemID = nil
        }
        guard let itemID1 = itemID else { return nil }

        if let primaryID = clazz.primaryKey(for: itemID1, andType: .internal) {
            itemCase[.primary] = primaryID
        }

        return LinkLookupRule(objectIdentifier: itemID, pkCase: itemCase)
    }
}

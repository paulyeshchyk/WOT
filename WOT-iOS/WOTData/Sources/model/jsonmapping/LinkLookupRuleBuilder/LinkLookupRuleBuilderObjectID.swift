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
    private var primaryKeyType: PrimaryKeyType
    private var clazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, primaryKeyType: PrimaryKeyType, clazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.primaryKeyType = primaryKeyType
        self.clazz = clazz
    }

    public func build() -> LinkLookupRule? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase()
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            itemID = json[idKeyPath]
        } else {
            itemID = nil
        }
        guard let itemID1 = itemID else { return nil }

        if let primaryID = clazz.primaryKey(for: itemID1, andType: primaryKeyType) {
            itemCase[.primary] = primaryID
        }

        return LinkLookupRule(ident: itemID, pkCase: itemCase)
    }
}

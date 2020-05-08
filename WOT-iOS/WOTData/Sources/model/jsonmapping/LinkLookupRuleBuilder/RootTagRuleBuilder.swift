//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class RootTagRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var json: JSON?
    private var linkedClazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, linkedClazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.linkedClazz = linkedClazz
    }

    public func build() -> LinkLookupRule? {
        guard let json = self.json else { return nil }

        let itemID: AnyObject?
        if let idKeyPath = linkedClazz.primaryKeyPath(forType: .local) {
            itemID = json[idKeyPath] as AnyObject
        } else {
            itemID = nil
            fatalError("need to debug")
        }
        guard let itemID1 = itemID else { return nil }

        let resultCase = PKCase()
        if let primaryID = linkedClazz.primaryKey(for: itemID1, andType: .local) {
            resultCase[.primary] = primaryID
        }

        return LinkLookupRule(objectIdentifier: itemID, pkCase: resultCase)
    }
}

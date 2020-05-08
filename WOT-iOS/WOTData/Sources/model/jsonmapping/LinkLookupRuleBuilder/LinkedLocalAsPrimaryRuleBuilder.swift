//
//  LinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class LinkedLocalAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: Any

    public init(linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: Any) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
    }

    public func build() -> LinkLookupRule? {
        let nextTanksPK = PKCase(parentObjectIDList: nil)
        nextTanksPK[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .local)

        return LinkLookupRule(objectIdentifier: nil, pkCase: nextTanksPK)
    }
}

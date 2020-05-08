//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: Any
    private var pkCase: PKCase
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(pkCase: PKCase, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: Any, parentObjectIDList: [NSManagedObjectID]?) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.pkCase = pkCase
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() -> LinkLookupRule? {
        let modulePK = PKCase(parentObjectIDList: parentObjectIDList)
        modulePK[.primary] = pkCase[.primary]
        modulePK[.secondary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .remote)

        return LinkLookupRule(objectIdentifier: nil, pkCase: modulePK)
    }
}

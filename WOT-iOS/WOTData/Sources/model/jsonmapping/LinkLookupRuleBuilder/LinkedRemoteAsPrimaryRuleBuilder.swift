//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class LinkedRemoteAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject?
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(parentObjectIDList: [NSManagedObjectID]?, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject?) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() -> LinkLookupRule? {
        let currentModulePK = PKCase(parentObjectIDList: parentObjectIDList)
        currentModulePK[.primary] = linkedClazz.primaryKey(for: linkedObjectID as AnyObject, andType: .remote)

        return LinkLookupRule(objectIdentifier: nil, pkCase: currentModulePK)
    }
}
